Bu modül, iki adet 32-bit'lik kayan nokta sayısını alır ve belirtilen işleme göre bu iki sayıdan en büyüğünü veya en küçüğünü seçer.

Girdiler
rs1 ve rs2: Karşılaştırılacak iki adet 32-bit'lik kayan nokta sayısı.
func_type: Yapılacak işlemi belirler. func_type = 1 ise en büyük sayıyı, func_type = 0 ise en küçük sayıyı seçer.
Çıkış
rd: Seçilen en büyük veya en küçük sayı.
İşleyiş
rs1 ve rs2 sayılarının işaret bitlerini, üs (exponent) ve mantissa değerlerini ayrıştırır.
rs1 ve rs2 sayılarının hangi sayının daha büyük olduğunu belirlemek için bu ayrıştırılan değerleri karşılaştırır.
func_type'a göre karar verir:
func_type = 1 ise: En büyük sayıyı rd çıkışına atar.
func_type = 0 ise: En küçük sayıyı rd çıkışına atar.
Bu şekilde, verilen iki sayının en büyüğünü veya en küçüğünü seçer ve sonucu rd çıkışına yazar.