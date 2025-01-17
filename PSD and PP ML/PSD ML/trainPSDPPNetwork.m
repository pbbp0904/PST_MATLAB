rng('default')
load('PulseGeneration\hard.mat');
addpath Networks\
layers = try2();
maxEpochs = 1024;
miniBatchSize = 64;
gpuDevice(1);
gpuDevice(2);
disp('Done with setup. Beginning training...')

options = trainingOptions('rmsprop','InitialLearnRate',1e-4,'MiniBatchSize',miniBatchSize,...
        'Shuffle','every-epoch','MaxEpochs',maxEpochs,...
        'ValidationData',{inputValidation,outputValidation},...
        'ValidationFrequency',round(10000/miniBatchSize),...
        'Plots','training-progress',...
        'ExecutionEnvironment','gpu');
net = trainNetwork(inputData,outputData,layers,options);
modelDateTime = datestr(now,'dd-mmm-yyyy-HH-MM-SS');
save(['trainedNet-' modelDateTime '-Data-' num2str(length(outputData)) ...
            '-Layers-' num2str(length(layers)) '.mat'],'net','options');

YPred = classify(net,inputValidation, ...
    MiniBatchSize=miniBatchSize);
acc = mean(YPred == outputValidation)
confusionchart(outputValidation,YPred);