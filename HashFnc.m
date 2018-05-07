
% -----------Hash function
%    Author: Behnam Anjomruz
%    Email: behnam.anjomruz@gmail.com
%       Description: Biohashing: this code is based on an article by Zhe Jin, et al (2012): 
%       Fingerprint template protection with minutiae-based bit-string for security and privacy preserving

%           Copyright (C) 2013

function bitstring = HashFnc(minutiae)

% clear all;
% clc
% minutiae = load('minutiae.mat');
h = size(minutiae.M);
h = h(1);




XYT = minutiae.M(1:h,[1,2,4]); %Minutiae points including X (first column), Y (second column), and Theta (third column in radius)
X_Max=max(XYT(1:h,1));
X_Min=min(XYT(1:h,1));

Y_Max=max(XYT(1:h,2));
Y_Min=min(XYT(1:h,2));

Wx = 2*(X_Max-X_Min+1);
Wy = 2*(Y_Max-Y_Min+1);



r = randi(h,1);


XYT_ref = XYT(r,1:3); % the reference minutiae which selected by a random index
X_r = XYT_ref(1);
Y_r = XYT_ref(2);
theta_r = XYT_ref(3);
rotMat = [cos(theta_r) -sin(theta_r); sin(theta_r) cos(theta_r)];

XYT(r,:)=[]; % removing the refrence minutiae
h = h-1;
 
theta = rad2deg(XYT(1:h,3)); %converting radius to degree

XYT(1:h,3) = theta;



col1 = XYT(1:h,1) - X_r;
col2 = -(XYT(1:h,2) - Y_r);

XY_t = XYT(1:h,[1 2]);

col3 = XYT(1:h,3);
for i = 1:h
    if i == r
        continue;
    end
    
    temp = [(XYT(i,1) - X_r);-(XYT(i,2) - Y_r)];
    
    XY_t(i,[1 2]) = rotMat * temp;
    
    th = XYT(i,3); % "th" is the Theta
    if th >= theta_r
        col3(i) = th - theta_r;
    else
        col3(i) = 360 + th - theta_r;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%% Shifting


XYT_Shifted = [XY_t(1:h,1)+(Wx/2), XY_t(1:h,2)+ (Wy/2), col3];



%____________________Polar Transform

RHO = sqrt((XYT_Shifted(1:h,1)).^2+(XYT_Shifted(1:h,2).^2)); % Radial distance

% Alpha = atan2((XYT_Shifted(1:h,2)),(XYT_Shifted(1:h,1)));


% [Alpha,RHO,Z] = cart2pol(XYT_Shifted(1:h,1),XYT_Shifted(1:h,2),XYT_Shifted(1:h,3));
% [THETA,RHO] = cordiccart2pol(XYT_Shifted(1:h,1),XYT_Shifted(1:h,2));


% CAlpha=radtodeg(Alpha);
% [THETA1,RHO1] = cart2pol(XYT_Shifted(1:h,1),XYT_Shifted(1:h,2));

CTheta=XYT_Shifted(1:h,3);
polar(CTheta,RHO,'*');



% ____________________polar scan
l = 200;
o = 30;

Poles=zeros(h,5);

p=(360/o)*(1000/l);
counter=zeros(360/o,1000/l);
bitstring=zeros(1,p);

for k=1:h
    ci=1;
    cj=1;
    for i=0:o:360-o
        if ((CTheta(k)>= i)&&(CTheta(k)<i+o))
            for j=0:l:1000-l
                if ((RHO(k)>=j)&&(RHO(k)<j+l))
                    Poles(k,1)=RHO(k);
                    Poles(k,2)=CTheta(k);
                    Poles(k,3)=j;
                    Poles(k,4)=i;
                    counter(ci,cj)=counter(ci,cj)+1;
                    bitstring(1,ci*cj)=1;
                end
                cj=cj+1;
            end
        end
        ci=ci+1;
    end
end

XYT=[XYT(1:r-1,:);XYT_ref;XYT(r:h,:)];


end


























