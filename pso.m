clear;
clc;
%%
rng default
nvars = 3;
lb = [0,0,0];
ub = [100,100,1];

fun = @obj_fun
options = optimoptions('particleswarm','MaxTime',30,'UseParallel',true);
x_opt = particleswarm(fun,nvars,lb,ub,options);

%%
param = x_opt;
% param = [10,1,1];

figure()
out = pid_sim(param);
plot(out.y.Time,out.y.Data)
obj_fun(param)

%%
function out =  pid_sim(param)
assignin('base','kp',param(1))
assignin('base','ki',param(2))
assignin('base','kd',param(3))
out = sim('pid_1');
end

%%
function out = obj_fun(param)
tmp=pid_sim(param);
t = tmp.y.Time;
y = tmp.y.Data;
N = size(y,1);

sigma =max(0,max(y-10));

y_err = y<0.95*y(end);

y_err_flat =reshape(y_err,[1,N]);
[~,ts_rev_idx]=max(fliplr(y_err_flat));
ts_idx = N-ts_rev_idx+1;
ts = t(ts_idx);

w_a=5
w_b=5
w_c=10
out = w_a*abs(ts)+w_b*abs(sigma)+w_c*abs(10-y(end))
end

