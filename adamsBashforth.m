function y_pred = adamsBashforth(f, t_hist, y_hist, h)

    f0 = reshape(f(t_hist(1), y_hist(1,:)), 1, []);
    f1 = reshape(f(t_hist(2), y_hist(2,:)), 1, []);
    f2 = reshape(f(t_hist(3), y_hist(3,:)), 1, []);
    f3 = reshape(f(t_hist(4), y_hist(4,:)), 1, []);
    y_pred = y_hist(4,:) + h * (55/24*f3 - 59/24*f2 + 37/24*f1 - 9/24*f0);
end
