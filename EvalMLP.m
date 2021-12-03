function Z = EvalMLP(Data)

Inputs = Data(:,1:end-1)';
Targets = Data(:,end);
Targets = Targets(:)';

LS = [5 3];
TF = {'tansig', 'tansig','tansig'};
net=newff(Inputs,Targets,LS,TF);

net.trainParam.showWindow=false;
net.trainParam.showCommandLine=false;
net.trainParam.show=1;
net.trainParam.epochs=100;
net.trainParam.goal=1e-6;
net.trainParam.max_fail=10;


[net,tr]=train(net,Inputs,Targets);
out = sign(net(Inputs));
valInd=tr.valInd;
testInd=[tr.testInd valInd];
Targets = Targets(:,testInd);
out = out(:,testInd);





d = (out - Targets);
TP1=0;TN1=0;
    FP1=0;FN1=0;
    for n=1:numel(Targets)
        if sum(abs(d(n)))>0
            if Targets(n)==1
                FN1=FN1+1;
            else
                FP1=FP1+1;
            end
        end
        if sum(abs(d(n))==0)
            if Targets(n)==1
                TP1=TP1+1;
            else
                TN1=TN1+1;
            end
        end
    end
    
    SENSITIVITY1=100*(TP1/(TP1+FN1));
    SPECIFICITY1=100*(TN1/(TN1+FP1));
    ACC1=100*((TP1+TN1)/(TP1+TN1+FP1+FN1));
    
    Z=[SENSITIVITY1 , SPECIFICITY1,ACC1];