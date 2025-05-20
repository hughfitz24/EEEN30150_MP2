function y_corr = adamsMoulton(f, t_hist, y_hist, h, y_pred)
    f_nm2     = reshape(f(t_hist(1),    y_hist(1,:)), 1, []);
    f_nm1     = reshape(f(t_hist(2),    y_hist(2,:)), 1, []);
    f_n       = reshape(f(t_hist(3),    y_hist(3,:)), 1, []);
    f_np1_pred= reshape(f(t_hist(4),    y_pred    ), 1, []);
    y_corr = y_hist(3,:) + h * (9/24*f_np1_pred + 19/24*f_n - 5/24*f_nm1 + 1/24*f_nm2);
end
