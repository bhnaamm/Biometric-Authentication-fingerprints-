clear all
clc
START=1; FINISH=8;


%    Author: Joshua Abraham
%    Email: algorithm007@hotmail.com
%    Description: Extracts and stores the features of a fingerprint database.
%                 Currently, the extraction is tuned for the FVC2002 DB1 database.  
%                    All features are stored in csv files in the database directory.
%
%    Behnam Anjomruz,
%    Email: behnam.anjomruz@gmail.com
%    Description: Appending hashcodes to features 
%
%
%

% ---------
DB_Number=100; %The umber of the pictures in the Database
% bit_Size=60;  %The size of bitstring which can be filled dynamically
% ---------


%files = dir('C:\FVC2002\Dbs\Db1_a\*.tif');
%cd  'C:\FVC2002\Dbs\Db1_a';

files = dir('Db1_a\*.tif');

% cd  'C:\Users\Behnam\Desktop\Current Works\DUST2\sc_minutia\Db1_a';

IMPRESSIONS_PER_FINGER=8;
file_names = {files.name};

index1 = START;
bitstrings=cell(FINISH*DB_Number,3);
while index1 <= FINISH
  finger_features=struct('X', [], 'M', [], 'O', [], 'R', [], 'N', [], 'RO',[], 'OIMG', [], 'OREL', []); 
 kkkk=0;
  for i=0:IMPRESSIONS_PER_FINGER-1
       kkkk=kkkk+1;
      finger_features = extract_finger(char(file_names(index1 + i)));
      file_a = file_names(index1 + i);
      fOut = sprintf('%s.X', char(file_a));
      csvwrite(fOut, finger_features.X);
      fOut = sprintf('%s.m', char(file_a));
      csvwrite(fOut, finger_features.M);
      fOut = sprintf('%s.o', char(file_a));
      csvwrite(fOut, finger_features.O);
      fOut = sprintf('%s.r', char(file_a));
      csvwrite(fOut, finger_features.R);
      fOut = sprintf('%s.n', char(file_a));    
      csvwrite(fOut, finger_features.N); 
      fOut = sprintf('%s.ro', char(file_a));                                           
      csvwrite(fOut, finger_features.RO);   
      fOut = sprintf('%s.oi', char(file_a));                                           
      csvwrite(fOut, finger_features.OIMG);   
      fOut = sprintf('%s.or', char(file_a));                                           
      csvwrite(fOut, finger_features.OREL);
      
      % ---------bitstring 
      bitstrings{i+1,1}= strtok(file_a,'_');
      bitstrings{i+1,2}=i+1;
      bitstrings{i+1,3}=HashFnc(finger_features);
  end

  file_a = file_names(index1);

 file_a = substring(char(file_a), 0, strfind(char(file_a), '_')-2);
  index1 = index1 + IMPRESSIONS_PER_FINGER;
end
save('bitstrings.mat','bitstrings');
% save('minutiae.mat','-struct','finger_features','M');




