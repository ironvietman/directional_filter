function kernel = kernel_build(L, theta)
I = ((-L/2):(L/2))'; % displacement values for making del_i and del_j

 [col row] = pix_displace(theta,I); % Find displacement values in x and y direction

 kernel = zeros(L+1); % intialize the kernel
shift_center = round(length(col)/2); % Converts to 0,0 point from center to left upper corner

for i=1:length(col) % from center build out to get the linear template
kernel(row(i)+shift_center,col(i)*(-1)+shift_center)=1;
end
