function [Strain_p,Strain_e,Strain_a,Tau_m,Tau_a,G_right,G_left,G,K,nn] = HystLoop_DH(eStrain,tau,N_HystLoop)
    fnum=160;%周期采样点 
    eSpMax_Index=[];
    eSpMin_Index=[];
    a1=[];
    b1=[];
    a2=[];
    b2=[];
    
    % N_HystLoop=100;
    for k=1:N_HystLoop %计算周期数
        ftau=tau((k-1)*fnum+1:k*fnum);
        fStrain=eStrain((k-1)*fnum+1:k*fnum);
        epsMin(k)= (min(fStrain));
        epsMax(k)= (max(fStrain));
        tauMin(k) = (min(ftau));
        tauMax(k) = (max(ftau));

        ftau_temp=tau((k-1)*fnum+1:k*fnum);
        correct_tau=tauMax-((tauMax-tauMin)/2);
        ftau_temp=ftau_temp-correct_tau(k);
        fStrain_temp=eStrain((k-1)*fnum+1:k*fnum);
        correct_strain=epsMax-((epsMax-epsMin)/2);
        fStrain_temp=fStrain_temp-correct_strain(k);

        epsMin_temp(k)= (min(fStrain_temp));
        epsMax_temp(k)= (max(fStrain_temp));
        tauMin_temp(k) = (min(ftau_temp));
        tauMax_temp(k) = (max(ftau_temp));

        StrainIndexmore0=find(fStrain_temp>0);
        pMaxIndex=find(fStrain_temp==epsMax_temp(k));
        eSpMax_Index=[eSpMax_Index,pMaxIndex(1)];
        pMaxIndex=[];

       if(eSpMax_Index(k)<130)

        x=fStrain_temp(eSpMax_Index(k):(eSpMax_Index(k)+30));
        y=ftau_temp(eSpMax_Index(k):(eSpMax_Index(k)+30));
        size(x);
        size(y);
        p=polyfit(x,y,1);


        a1=[a1,p(1)];
        b1=[b1,p(2)];

        eSp_Plastic(k)=-b1(k)/a1(k);
       else
             x1=fStrain_temp(eSpMax_Index(k):160);
            x2=fStrain_temp(1:(30-(160-eSpMax_Index(k))));
            x=[x1',x2'];
                    y1=ftau_temp(eSpMax_Index(k):160);
            y2=ftau_temp(1:(30-(160-eSpMax_Index(k))));
            y=[y1',y2'];

        p=polyfit(x,y,1);
    %     plot(x, polyval(p, x));

        a1=[a1,p(1)];
        b1=[b1,p(2)];

        eSp_Plastic(k)=-b1(k)/a1(k);
       end
    %左侧G
        pMinIndex=find(fStrain_temp==epsMin_temp(k));
        eSpMin_Index=[eSpMin_Index,pMinIndex(1)];
        pMinIndex=[];

       if(eSpMin_Index(k)<130)

        x=fStrain_temp(eSpMin_Index(k):(eSpMin_Index(k)+30));
        y=ftau_temp(eSpMin_Index(k):(eSpMin_Index(k)+30));
        p=polyfit(x,y,1);


        a2=[a2,p(1)];
        b2=[b2,p(2)];

        eSp_Plastic(k)=-b1(k)/a1(k);
       else
             x1=fStrain_temp(eSpMin_Index(k):160);
            x2=fStrain_temp(1:(30-(160-eSpMin_Index(k))));
            x=[x1',x2'];
                    y1=ftau_temp(eSpMin_Index(k):160);
            y2=ftau_temp(1:(30-(160-eSpMin_Index(k))));
            y=[y1',y2'];

        p=polyfit(x,y,1);
    %     plot(x, polyval(p, x));

        a2=[a2,p(1)];
        b2=[b2,p(2)];
        end    
    end
    G_right=a1(N_HystLoop);
    G_left=a2(N_HystLoop);
    G=(G_right+G_left)/2;

    espElastic=epsMax_temp-eSp_Plastic;
    x2=ftau_temp-tauMin_temp(N_HystLoop);
    y3=fStrain_temp-epsMin_temp(N_HystLoop);
    y2=y3-x2/G;


    ft_index=eSpMax_Index(N_HystLoop);
    if(ft_index>60)  
        x1=x2(ft_index-60:ft_index-20);
        y1=y2(ft_index-60:ft_index-20);
    else
        if(ft_index>20)
            x1_1=x2(1:ft_index-20);
            x1_2=x2(160-(60-ft_index):160);
            x1=[x1_1',x1_2'];
            y1_1=y2(1:ft_index-20);
            y1_2=y2(160-(60-ft_index):160);
            y1=[y1_1',y1_2'];
        end
    end


    ft=fittype('2*(x1./2*A).^B','independent','x1','coefficients',{'A','B'});
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    % opts.Lower = [1000 5];
    opts.StartPoint = [1  7.5];
    % opts.Upper = [10000 20];
    cfun1=fit(x1,y1,ft,opts);

    K=1/cfun1.A;
    nn=1/cfun1.B;


    Strain_a=epsMax_temp(N_HystLoop);
    Strain_e=espElastic(N_HystLoop);
    Strain_p=eSp_Plastic(N_HystLoop);
    Tau_m=tauMax_temp(N_HystLoop);
    Tau_a=tauMax_temp(N_HystLoop);
end
