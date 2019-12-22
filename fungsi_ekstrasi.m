function [mean, deviasi, kew] = fungsi_ekstrasi(gambar)
mean = sum(double(gambar(:)), 1)./ numel(gambar);
[rows, columns] = size(gambar);
k = numel(gambar);
sdev = 0;
for col=1:columns;
    for row=1:rows
        sdev =sdev + ((gambar(row,col)-mean)^2);
    end
end
deviasi =sqrt(sdev/(k-1));


skew = 0;
for col=1:columns;
    for row=1:rows
        skew =skew + ((gambar(row,col)-mean)^3);
    end
end
kew =(skew/(k-1))^(1/3);

end