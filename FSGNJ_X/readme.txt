Bu modül, iki adet 32-bit'lik IEEE 754 tek hassasiyetli (single-precision) kayan nokta sayısını alır ve belirli bir işleme göre bu sayıların işaret ve büyüklük bitlerini manipüle ederek sonucu üretir. İşlem türü op_type girişi ile belirlenir.

Girdiler
rs1: 32-bit'lik kayan nokta sayısı.
rs2: 32-bit'lik kayan nokta sayısı.
op_type: 2-bit'lik işlem türü seçici.
Çıkış
rd: 32-bit'lik sonuç.
İşleyiş
Bileşenlerin Ayrıştırılması
rs1 ve rs2 sayılarının işaret bitleri ve büyüklük (magnitude) bitleri ayrıştırılır.
sign_1 ve sign_2: rs1 ve rs2 sayıların işaret bitleri.
magnitude_1 ve magnitude_2: rs1 ve rs2 sayıların işaret bitleri haricindeki bitleri.
İşlemler
op_type sinyaline göre aşağıdaki işlemler gerçekleştirilir:

op_type == 2'b00 (fsgnj.s):

rd çıkışının büyüklük kısmı (rd[30:0]) rs1 sayısının büyüklük kısmı ile aynıdır.
rd çıkışının işaret bit kısmı (rd[31]) rs2 sayısının işaret biti ile aynıdır.
op_type == 2'b01 (fsgnjn.s):

rd çıkışının büyüklük kısmı (rd[30:0]) rs1 sayısının büyüklük kısmı ile aynıdır.
rd çıkışının işaret bit kısmı (rd[31]) rs2 sayısının işaret bitinin tersidir (~sign_2).
op_type == 2'b10 (fsgnjx.s):

rd çıkışının büyüklük kısmı (rd[30:0]) rs1 sayısının büyüklük kısmı ile aynıdır.
rd çıkışının işaret bit kısmı (rd[31]) rs1 ve rs2 sayılarının işaret bitlerinin XOR işlemine göre belirlenir (sign_1 ^ sign_2).
op_type == 2'b11 (default):

rd çıkışının büyüklük kısmı (rd[30:0]) rs1 sayısının büyüklük kısmı ile aynıdır.
rd çıkışının işaret bit kısmı (rd[31]) rs1 sayısının işaret bitine göre belirlenir.
Özet
Bu modül, iki kayan nokta sayısını alır ve seçilen işlem türüne göre işaret bitlerini manipüle ederek sonucu üretir. Sonuç, rd adlı 32-bit'lik çıkışta elde edilir. Bu işlemler, işaret biti manipülasyonları gerektiren çeşitli uygulamalarda kullanılabilir.