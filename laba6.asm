data segment        
cnt db 0        
tmplen1 db 0        
tmplen2 db 0        
cmp_str1 db 255 dup(?)
cmp_str2 db 255 dup(?)  
str_arr db 1000 dup(?) 
indx_arr db 1000 dup(?) 
mlen db 064h           
alen db ?       
strng db 255 dup(?) 
ln db 13,10,'$' 
flag db 0       
tmp dw ?        
end_of_indx_arr dw ?    
data ends       
code segment        
assume cs:code,ds:data  
 
compare proc far
CLD         
xor cx,cx
mov cl,tmplen1      
cmp cl,tmplen2      
ja CmpLbl1
CmpLbl2:
lea di,cmp_str1 
lea si,cmp_str2
repe cmpsb      
jae ext_cmp     
mov flag,1      
ext_cmp:
ret 
CmpLbl1:
mov cl,tmplen2      
jmp CmpLbl2 
compare endp
 
read proc far
lea bx,indx_arr
strt:
mov ah,0Ah  
lea dx,mlen
int 21h         
mov ah,09h  
lea dx,ln
int 21h         
mov cl,alen
jcxz ext        
lea si,strng            
inc di  
mov byte ptr [bx],cl    
mov word ptr [bx+1],di  
add bx,3        
rep movsb       
mov byte ptr[di],'$'    
add cnt,1       
jmp strt        
ext:
xor di,di   
mov end_of_indx_arr,bx  
sub end_of_indx_arr,3
ret
read endp
 
sort proc far
xor cx,cx
lea di,cmp_str1 
mov si,[bx+1]       
mov word ptr ax,[bx+1]  
mov byte ptr cl,[bx]    
mov tmplen1,cl      
rep movsb       
add bl,3        
lea di,cmp_str2;    
mov si,[bx+1]       
push ax         
mov ax,word ptr [bx+1]  
mov tmp,ax      
pop ax          
mov byte ptr cl,[bx]    
mov tmplen2,cl      
rep movsb           
call compare        
cmp flag,1      
je SrtLbl1      
ext_srt:        
mov flag,0      
ret
SrtLbl1:
push ax         
xor ax,ax
mov al,tmplen1      
mov [bx],al     
pop ax          
mov word ptr [bx+1],ax  
sub bx,3        
xor ax,ax
mov al,tmplen2      
mov [bx],al     
mov ax,tmp      
mov word ptr [bx+1],ax  
add bx,3        
jmp ext_srt
sort endp
 
main:
mov ax,data
mov ds,ax
mov es,ax
xor bx,bx
lea di,str_arr      
call read       
mov cl,cnt      
cycle2:
push cx 
lea bx,indx_arr     
mov cx,end_of_indx_arr  
cycle1:
cmp cx,bx   
je Main_loop_lbl    
push cx 
call sort       
pop cx
jmp cycle1
Main_loop_lbl:
pop cx
loop cycle2     
main_ext:
xor ax,ax
xor cx,cx
mov cl,cnt
lea bx,indx_arr
 
cycle3:
mov ah,09h
push cx
mov word ptr dx,[bx+1]
int 21h         
mov ah,09h
lea dx,ln       
int 21h
add bx,3        
pop cx
loop cycle3     
mov ax,4c00h
int 21h
code ends
end main