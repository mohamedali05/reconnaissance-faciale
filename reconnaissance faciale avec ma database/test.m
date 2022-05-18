clear ; close all ; 

A= dir ("TestDatabase") ; 
prompt = {'Enter test image name (a number between 1 to 10):'};
dlg_title = 'Input of PCA-Based Face Recognition System';
num_lines= 1;
def = {'1'} ; 

TestImage  = inputdlg(prompt,dlg_title,num_lines,def);
n =char(TestImage) ; 
 B = imread ([A(2+n).folder, '/' , n , .jpg]) ;
% imshow(B) ; 