train_length = 128;
learning_rate = 10;
tolerance = 0.1;
slowdown = true;

file_RX = 'data/data_Binary_NRZ_RX(small).csv';
file_labels = 'data/labels_Binary_NRZ_TX.csv';
class_pos = [1];
class_neg = [0];
shuffle = true;

[training_set, test_set] = data_parser(file_RX, file_labels, train_length, class_pos, class_neg, shuffle);

regularizers = 0:1e-6:3e-4;
missed_data = zeros(length(regularizers), 1);
loss_data = zeros(length(regularizers), 1);
epoch_data = zeros(length(regularizers), 1);
w_data = zeros(length(regularizers), 1);

for n=1:length(regularizers)
    disp(n);
    reg_pen = regularizers(n);
    [epoch, loss, w, b] = SVM_train(training_set, reg_pen, learning_rate, tolerance, slowdown);
    epoch_data(n) = epoch;
    w_data(n) = norm(w);
    [avg_loss, misclass] = SVM_test(test_set, w, b, reg_pen);
    loss_data(n) = avg_loss;
    missed_data(n) = misclass;
end

hold on
title('Soft-margin SVM Training Results vs. Regularizer (Binary)')
xlabel('Regularizer \lambda')
xlim([0 regularizers(end)])
yyaxis right
ylabel('Loss')
plot(regularizers, loss_data)
yyaxis left
ylabel('||w||')
plot(regularizers, w_data)