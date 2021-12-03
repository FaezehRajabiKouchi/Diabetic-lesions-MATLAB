
function Z = EvalSVM(a)

[m,nn]=size(a);




for kk = 1:nn-1
    a(:,kk) = Normalize_Fcn(a(:,kk),min(a(:,kk)),max(a(:,kk)));
end


id = find(a(:,end) == 1);
class1 = a(id,:);
b = a;
b(id,:) = [];
class2 = b;
d1 = numel(id);
d2 = m - d1;

kn = 30;
result = zeros(kn,3);
for Q=1:kn
    
    
    d=randperm(d1);
    d=d';
    class1=class1(d,:);
    d=randperm(d2);
    d=d';
    class2=class2(d,:);
    
    
    class1=[class1(:,1:nn-1) ones(d1,1) -ones(d1,1) ];
    class2=[class2(:,1:nn-1) -ones(d2,1) ones(d2,1) ];
    
    
    w=(d1)-(d2);
    m1=d1;m2=d2;
    if w>=0
        train=[class1(1:fix(0.7*m2),:);class2(1:fix(0.7*m2),:)];
        test=[class1(fix(0.7*m2)+1:m1,:);class2(fix(0.7*m2)+1:m2,:)];
    else
        train=[class1(1:fix(0.7*m1),:);class2(1:fix(0.7*m1),:)];
        test=[class1(fix(0.7*m1)+1:m1,:);class2(fix(0.7*m1)+1:m2,:)];
    end
    [m3,~]=size(train);
    d=randperm(m3);
    train=train(d,:);
    
    sample=test(:,1:nn-1);
    training=train(:,1:nn-1);
    group=train(:,end);    
    
    t = templateSVM('Standardize',1,'KernelFunction','linear');
    svmRBF = fitcecoc(training,group,'Learners',t);
    class = predict(svmRBF,sample);
    
    ytf=test(:,end);
    [c2 ,~]=size(ytf);
    yfh=class(:,1);
    
    TP1=0;TN1=0;
    FP1=0;FN1=0;
    d=ytf-yfh;
    for n=1:c2
        if sum(abs(d(n,:)))>0
            if ytf(n,1)==1
                FN1=FN1+1;
            else
                FP1=FP1+1;
            end
        end
        if sum(abs(d(n,:))==0)
            if ytf(n,1)==1
                TP1=TP1+1;
            else
                TN1=TN1+1;
            end
        end
    end
    
    SENSITIVITY1=100*(TP1/(TP1+FN1));
    SPECIFICITY1=100*(TN1/(TN1+FP1));
    ACC1=100*((TP1+TN1)/(TP1+TN1+FP1+FN1));
    
    result(Q,:)=[SENSITIVITY1 , SPECIFICITY1,ACC1];
end

Z = mean(result)';