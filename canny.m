# canny_algorithm
function[]=canny_algorithm()
clc
im=imread('cameraman.tif');
subplot(3,3,1)
imshow(im); title('Original');
im_smooth=fspecial('Gaussian',[5 5],1.4 );
smooth_img=imfilter(im,im_smooth);

H = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],10); % create unsharp mask % create unsharp mask

sharp_img = imfilter(smooth_img,H);  % create a sharpened version of the image using that mask

[fx,fy] = GRADIENT(double(sharp_img) );

[row,col]=size(fy);

mag=[];
fai=[];
ranges=[];

for i=1:row
    for j=1:col
        mag(i,j)=sqrt(fx(i,j)^2+fy(i,j)^2);
        fai(i,j)=(atan(fy(i,j)/fx(i,j))*180)/pi;
        
  if (fai(i,j)<0)
      fai(i,j)=fai(i,j)+180;
      
    
  end
    
  if (22.5>fai(i,j)&&fai(i,j)>=0)
      ranges(i,j)=0;
 elseif(180> fai(i,j)&& fai(i,j)>=157.5)
     ranges(i,j)=0;
  elseif  (57.5> fai(i,j)&& fai(i,j)>=22.5)
     ranges(i,j)=45;
      
    
  elseif  (90>fai(i,j)&&fai(i,j)>=57.5)||(112.5> fai(i,j)&&fai(i,j)>=90 )
     ranges(i,j)=90;
      
  
  elseif  (157.5> fai(i,j)&&fai(i,j)>=112.5)
     ranges(i,j)=135;
      
  else
      ranges(i,j)=fai(i,j);
  

  end
    end


end
subplot(3,3,2)
imshow(mag);title('Magnitude')

%%%%%%%%%%%%%%%%%%%%%%%%%%thinning
mag= padarray(mag,[1 1],'both');
newmag=[];
for x=1:row
 for y=1:col
     %%%%%%%%%%%%%0
     if  ranges(x,y)==0
         if mag(x+1,y+1)>mag(x+1,y)&&mag(x+1,y+1)>mag(x+1,y+2)
         newmag(x,y)=mag(x+1,y+1);
         else
          newmag(x,y)=0;
         end
         %%%%%%%%%%%90
     elseif ranges(x,y)==90
         if mag(x+1,y+1)>mag(x,y+1)&&mag(x+1,y+1)>mag(x+2,y+1)
           newmag(x,y)=mag(x+1,y+1);
         else 
           newmag(x,y)=0;
         end 
         
         
         
         %%%%%%%%%%%%45
       elseif ranges(x,y)==45
           if mag(x+1,y+1)>mag(x,y+2)&&mag(x+1,y+1)>mag(x+2,y)
           newmag(x,y)=mag(x+1,y+1);
           else
               newmag(x,y)=0;
           end
           
           %%%%%%%%%%135
            elseif ranges(x,y)==135
               if mag(x+1,y+1)>mag(x,y)&&mag(x+1,y+1)>mag(x+2,y+2)
           newmag(x,y)=mag(x+1,y+1);
           else
               newmag(x,y)=0;
           end
                %%%%%%%%%%%%%nan case
     else 
         newmag(x,y)=0;
     end
 end
end
    
   
ranges;
fx;
subplot(3,3,3)
imshow(newmag);title('thining')
newmag;

maxx=min(min(newmag));
thmax=20;
thmin=10;
newmag1=[];
for a=1:row
    for b=1:col
      if newmag(a,b)>=thmax
         newmag1(a,b)=newmag(a,b);
      elseif newmag(a,b)<thmin
          newmag1(a,b)=0;
      else 
          newmag1(a,b)=100;
    end
    end
end
newmag1= padarray(newmag1,[1 1],'both');
final=[];
for k=2:row+2
 for y=2:col+2
    if newmag1(k,y)==100 
      if newmag1(k,y)> (newmag1(k,y+1)|| newmag1(k,y-1)|| newmag1(k-1,y-1)||newmag1(k-1,y)||newmag1(k-1,y+1)||newmag1(k+1,y-1)||newmag1(k+1,y)||newmag1(k+1,y+1))
          newmag1(k,y)=newmag(k-1,y-1);
      else
          newmag1(k,y)=0;
      end
    end
        
    end
end
 newmag1=newmag1(2:row-1,2:col-1)
 subplot(3,3,4)
 imshow(newmag1);title('Canny-algorithm')
th=0.2;
build_fun=edge(im,'canny',[0.4*th th ]);
subplot(3,3,5)
 imshow(build_fun);title('Built-in')
        se = strel('line',3,90);
        dilatedI = imdilate(newmag1,se);
         subplot(3,3,6)
 imshow( dilatedI);title('filled')
 
end


