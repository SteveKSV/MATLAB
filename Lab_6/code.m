%% 1. Завантаження зображень
I_color = imread('peppers.png');   % кольорове
I_gray  = imread('cameraman.tif'); % ч/б

figure, imshow(I_color), title('Кольорове зображення');
figure, imshow(I_gray), title('Чорно-біле зображення');

%% 2. Перетворення в відтінки сірого
I_color_gray = rgb2gray(I_color);
figure, imshow(I_color_gray), title('Кольорове -> Сіре');

%% 3. Параметри ДКП
N = 8; % розмір блоку
T = dctmtx(N); % матриця ДКП

% функції для blockproc
dct_fun = @(block_struct) T * double(block_struct.data) * T';
invdct_fun = @(block_struct) T' * block_struct.data * T;

%% 4. Поблочне ДКП
B = blockproc(I_color_gray, [N N], dct_fun);

% Відображення (лог масштаб)
figure, imshow(log(abs(B)+1), []), title('ДКП (лог масштаб)');

%% 5. Відновлення без квантування
I_rec = blockproc(B, [N N], invdct_fun);
I_rec = uint8(I_rec);

figure, imshow(I_rec), title('Відновлене без квантування');

%% 6. Квантування (різні N)
Q_values = [5, 10, 20];

for i = 1:length(Q_values)
    Q = Q_values(i);

    % квантування
    Bq = Q * round(B / Q);

    % відновлення
    I_q = blockproc(Bq, [N N], invdct_fun);
    I_q = uint8(I_q);

    figure, imshow(I_q), title(['Квантування, N = ', num2str(Q)]);
end

%% 7. Додаткове квантування (JPEG-подібна матриця)
Qmatrix = [
    16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99
];

% квантування по блоках
quant_fun = @(block_struct) round(block_struct.data ./ Qmatrix);
dequant_fun = @(block_struct) block_struct.data .* Qmatrix;

Bq2 = blockproc(B, [N N], quant_fun);
Bq2 = blockproc(Bq2, [N N], dequant_fun);

%% 8. Відновлення після квантування
I_q2 = blockproc(Bq2, [N N], invdct_fun);
I_q2 = uint8(I_q2);

figure, imshow(I_q2), title('JPEG-подібне квантування');