function fits = Fits(pop)
    num = size(pop,1);
    fits = zeros(num,1);
    for i = 1:num
       fits(i) = Fun(pop(i,1),pop(i,2));
    end
end