figH = figure;
imagesc(rand(400,600));
bb = uicontrol('Style', 'pushbutton', 'Callback', 'uiresume(gcbf)','String','Middle One');
cc = uicontrol('Style', 'pushbutton', 'Callback', 'uiresume(gcbf)','String','Left One');
disp('Step one - please press button');
drawnow; % Don't know, if this is needed.
uiwait(figH);
disp('Step two - please press button');
drawnow; % Don't know, if this is needed.
uiwait(figH);
disp('ready')

