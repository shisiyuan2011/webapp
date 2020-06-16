function [tauMax_temp,a1,a2,a3,N_all] = G_Tau_N(eStrain,tau,N_a, fnum)
eSpMax_Index=[];
eSpMin_Index=[];
a1=[];
b1=[];
a2=[];
b2=[];

delta = 0;
if fnum < 200
    delta = 30;
else
    delta = 40;
end

% N_HystLoop=100;
for k=1:N_a %计算周期数
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
    
   if(eSpMax_Index(k)<(fnum - delta))
       
    x=fStrain_temp(eSpMax_Index(k):(eSpMax_Index(k)+delta));
    y=ftau_temp(eSpMax_Index(k):(eSpMax_Index(k)+delta));
    p=polyfit(x,y,1);

    
    a1=[a1,p(1)];
    b1=[b1,p(2)];
    
    eSp_Plastic(k)=-b1(k)/a1(k);
   else
         x1=fStrain_temp(eSpMax_Index(k):fnum);
        x2=fStrain_temp(1:(delta-(fnum-eSpMax_Index(k))));
        x=[x1',x2'];
                y1=ftau_temp(eSpMax_Index(k):fnum);
        y2=ftau_temp(1:(delta-(fnum-eSpMax_Index(k))));
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
    
   if(eSpMin_Index(k)<(fnum - delta))
       
    x=fStrain_temp(eSpMin_Index(k):(eSpMin_Index(k)+delta));
    y=ftau_temp(eSpMin_Index(k):(eSpMin_Index(k)+delta));
    p=polyfit(x,y,1);

    
    a2=[a2,p(1)];
    b2=[b2,p(2)];
    
    eSp_Plastic(k)=-b1(k)/a1(k);
   else
         x1=fStrain_temp(eSpMin_Index(k):fnum);
        x2=fStrain_temp(1:(delta-(fnum-eSpMin_Index(k))));
        x=[x1',x2'];
                y1=ftau_temp(eSpMin_Index(k):fnum);
        y2=ftau_temp(1:(delta-(fnum-eSpMin_Index(k))));
        y=[y1',y2'];
  
    p=polyfit(x,y,1);
%     plot(x, polyval(p, x));
    
    a2=[a2,p(1)];
    b2=[b2,p(2)];
    

    end    
   

   
end
a3=(a1+a2)/2;
N_all=(1:1:N_a);