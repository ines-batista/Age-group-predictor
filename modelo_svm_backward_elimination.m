%SVM MODEL

%Final Work of Biostatistics | Group 10 - Inês Félix & Xavier Pinho

filename = 'grupo10.csv';  %obtaining data

indaccuracy = { };
line = 1;
iter = 8;
bestData = [];
%%
while iter>0
    best = 0;
    for i=1:1:iter+1
        
        headerLines = 1;
        
        if iter == 8 
            dataCol = 1:9;
        
        
        else
            dataCol = bestRow;
            
        end
        dataCol(:,i)=[];
        classeCol   = 10;
        
        dataStruct = importdata(filename, ',', 1);
        
        allData = dataStruct.data(:,dataCol);
        dataCol
        data    = zscore(allData);                  % matrix with the normalized data
        classif = dataStruct.data(:,classeCol);     % vector with the classes to which the cases belong
        varName = dataStruct.colheaders(dataCol);   % "cell" with the names of the data variables
        
        
        %% K-fold cross-validation
        KFold = 5;                                      % we used 5 but could have used another
        obj = cvpartition(classif, 'KFOLD', KFold);     % division of data into training sets and test sets
        
        %% Obtain the classification and performance model
        nHits = 0;
        nErrors   = 0;
        nCasos   = size(data,1);
        Taxa=[]; S=[];
        Lista=[];
        VP=0; FP=0; FN=0; VN=0;
        ja=[2,5];
        P=[];
        N=[];
        
        for ii = 1:KFold
            idxTrain = find(obj.training(ii) == 1);    % indexes of training data
            idxTest  = find(obj.test(ii) == 1);        % indexes of test data
            
            TrainData   = data(idxTrain,:);            % training data
            TrainClassif = classif(idxTrain,:);        % classification of training data
            
            TestData    = data(idxTest,:);             % test data dados para testar o modelo
            TestClassif  = classif(idxTest,:);         % classification of the test data
                      
            model_SVM  = fitcsvm(TrainData, TrainClassif);   % "hyperplane" obtained by the "linear" SVM 
            classifSVM = predict(model_SVM, TestData);        % "classifSVM" are the classes according to the model and the training data
           
            hits = sum(classifSVM == TestClassif);
            errors   = sum(classifSVM ~= TestClassif);
            
            nHits = nHits + hits;                          % total amount of hits
            nErrors   = nErrors + errors;                  % total amount of errors   
            
        end
        fprintf(1, 'Total of hits: %d\nTotal of errors:   %d\n', nHits, nErrors);
        fprintf(1, 'Accuracy: %6.2f%%\n', 100*nHits/nCasos);
        accuracy = 100*nHits/nCasos;
        
        if accuracy > best
            best = accuracy;
            bestData = dataCol;
        end
        
        indaccuracy {line,1} = dataCol;
        indaccuracy {line,2} = accuracy;
        
        line = line + 1;
        
        end
    bestRow = bestData;
    iter = iter-1;
    
end