function [tr te] = KNN(Z, encodedTestData, training_labels, test_labels, k)


if k==1
    [neighborIds neighborDistances] = kNearestNeighbors(Z', encodedTestData',1);


    sum=0;
    for i = 1:size(encodedTestData,2)
        if test_labels(i) ~= training_labels( neighborIds(i,1) ) %so we look at the label of the nearest neighbor here
            sum = sum +1;
        end
    end
    te = sum/size(encodedTestData,2);


    [neighborIds neighborDistances] = kNearestNeighbors(Z', Z',2);
    sum=0;
    for i = 1:size(Z,2)
        if training_labels(i) ~= training_labels( neighborIds(i,2) ) %so we look at the label of the nearest neighbor here
            sum = sum +1;
        end
    end
    tr = sum/size(Z,2);
    
elseif k==2
    [neighborIds neighborDistances] = kNearestNeighbors(Z', encodedTestData',2);

    sum=0;
    for i = 1:size(encodedTestData,2)
        if training_labels( neighborIds(i,1) ) + training_labels( neighborIds(i,2) ) == 0
               %I'll use whatever is closer instead of a random one. The close
               %one is at position (i,2)
                if rand(1)>.5
                    l=1;
                else
                    l=-1;
                end
                if training_labels( i ) ~=l 
                    sum = sum +1;
                end
        elseif sign(test_labels(i)) ~= sign(training_labels( neighborIds(i,1) ) + training_labels( neighborIds(i,2) ) )  %so we look at the label of the nearest neighbor here
            sum = sum +1;
        end
    end
    te = sum/size(encodedTestData,2);
    
    tr =1;
end