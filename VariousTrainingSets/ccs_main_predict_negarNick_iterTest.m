%{
NOTE ABOUT TC.MAT
It was trained over every 4th timestep (every 2 hours)
    with the radar and ir data
    for Sep 2012
Every 4th timestep was used, they were NOT accumulated
%}

% PERSIANN-CCS decision tree added
% Negar Karbalaee
% February 2016

% First of all we should load tc which is an object for
% model predi

%%%%%%%%%%%%% Image Size %%%%%%%%%%%%%%%%%%
% the model is trained over the CONUS
DIM=[1000,1750]; 
DIM2 = [500,750];
minV= [200 220 210  50   30   10   0  3  1   1  1  1];
maxV= [240 250 245  5000 3000 1000 8  15 10  6  6  10];
DistV=maxV-minV;  NBIN=10;

%%%%%% Parameters, Recommend use the default value%%%%%%%%%
dim=size(1000, 1750); THDH=253; MergeThd=10; S=10;

%files = dir('goes/bghrus1209*');
files = dir('irData/bghrus1109*');
%files = dir('zach_RR2/q2hrus1109*');
%load('tc.mat');

%load('tc_NickDecTreeResult_J128rf8.mat');
load('decTreeSepOct2012.mat');
XtrSet = Xtr;
NN = length(files);

precip = zeros(500,750);
precipNick = zeros(500,750);
precipCCS = zeros(500,750);

numToUse = 1;
numTotalTrees = 1;
treeNums = randperm(numTotalTrees);
boostStructArray = cell(1,numToUse);

%%
for JVALUE = [2]
    for ii = 1:numToUse
       curFile = ['SepOct2012Training_J' num2str(JVALUE) 'rf5_tree' num2str(treeNums(ii)) '.mat'];
       curFile
       curData = load(curFile,'boostStruct');
       boostStructArray{ii} = curData.boostStruct;
    end

    for i = [7,46,1,9,98,101]%1:NN
        i

        %fn =['goes/', files(i,1).name];
        fn =['irData/', files(i,1).name];
        fn3 = ['rrData/q2hrus', files(i,1).name(7:end)];
        fn2 = ['ccsData/rgo' files(i,1).name(7:end)];
        fn4 = ['patchesData/segs_feat' files(i,1).name(7:end)];

        if ~exist(fn,'file')
                    continue;
        end

        if ~exist(fn2,'file')
                    continue;
        end

        if ~exist(fn3,'file')
                    continue;
        end

        %if ~exist(fn4,'file')
        %            continue;
        %end

        %ir = loadbfn_bgz(fn, DIM, 'short')/100;
        load(fn);
        load(fn3);

        % area for training and testing over the US
        ir = ir(126:625,126:875);

        rrTest = rr(126:625,126:875);

        ccsData = load(fn2); ccsIR = ccsData.ccs;
        ccsOverUS = ccsIR(376:875,5751:6500);

        L=ccs_sub_seqsegment(ir,DIM2,THDH,MergeThd, S); %segmentation

       % Lrgb = label2rgb(L, 'jet', [0.8 0.8 0.8] ,'shuffle');

    %     figure(1)
    %     imshow = (Lrgb);


           NUM_FEATURE=12; WDSIZE=2;  MAXL=max(max(L));

                F=zeros(MAXL,NUM_FEATURE);
    beginning_of_loop = MAXL;
                for gg=1:MAXL
                   F(gg,1:(NUM_FEATURE) )=ccs_getFeature(ir,L,gg,NUM_FEATURE,WDSIZE,DIM2(1),DIM2(2));
                   FF(gg,:) = ( F(gg,:) - minV(1,:) )./ DistV(1,:);  %% Normalized the features
                end
    end_of_loop = 0;
                % post process features, avoid extremes
                 n=find(FF>2); FF(n)=2; n=find(FF<0); FF(n)=0;

        Xte = ccs_patchpixel_Feature(ir,L,MAXL,FF);


        [~,XtePct,~] = XToPct(XtrSet,Xte,256);

        %boostArgs.nIter = 10;

        %nickPreds = boostTreeVal3(boostStruct,totalIterTry,uint8(XtePct),boostArgs.v);
        boostArgs.v = 0.5; 
        rf = 0.9; 
        boostArgs.funargs = {rf JVALUE};
        totalIterTry = 10;
        nickPredsArray = cell(1,length(boostStructArray));
        for kk = 1:length(boostStructArray)
           nickPredsArray{kk} =  boostTreeVal3(boostStructArray{kk},totalIterTry,uint8(XtePct),boostArgs.v);
        end

        numRowMat = length(nickPredsArray{1}{1});
        for jj=1:totalIterTry
            jj
            precipNick = zeros(500,750);
            precipNick(ir<0) = -1;
            precipNick(L==0) = 0;

            predMatrix = zeros(numRowMat,length(boostStructArray));
            for kk=1:length(boostStructArray)
               predMatrix(:,kk) = nickPredsArray{kk}{jj};
            end
            avgPred = mean(predMatrix,2);
            %precipNick(ir>0 & L>0) = nickPreds{jj};   
            precipNick(ir>0 & L>0) = avgPred;   

            if(mod(jj,1)==0)
                %figInd = figInd + 1;
                fig = figure;
                imagesc(precipNick)
                colormap([1 1 1;0.8 0.8 0.8;jet(20)])
                caxis([-1 20]) 
                drwvect([-130 25 -100 45],[500 750],'us_states_outl_ug.tmp','k')
                colorbar('vertical')
                title(['Results after ' num2str(jj) ' trees applied for boosting'])
                %fileNm = ['sepOct2012PngFiles/SINGLE_J' num2str(JVALUE) 'rf9_time' num2str(i) '_Iter' num2str(jj) 'Map.png'];
                %print(fig,fileNm,'-dpng');
                pause(2);
                close(fig);
            end
        end



        pause(3)
    end
 
end


