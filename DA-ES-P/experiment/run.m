max_run = 12;
for func = 1:24
   delete(gcp('nocreate'));
   parpool('local',max_run);
   spmd(max_run)
       disp(func),disp(labindex);
       DA_ES(func, labindex);
   end
   delete(gcp('nocreate'));
end
 