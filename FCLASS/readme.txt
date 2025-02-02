Bu modül, tek hassasiyetli (single-precision) IEEE 754 formatındaki bir kayan nokta sayısını alır ve bu sayının sınıfını belirler. Sınıf, sayının pozitif/negatif sıfır, pozitif/negatif sonsuzluk, pozitif/negatif normal, pozitif/negatif altnormal, veya NaN (Not a Number) olup olmadığını ifade eder.

Girdiler
rs1: 32-bit'lik kayan nokta sayısı.
Çıkış
rd: 10-bit'lik sınıflandırma maskesi. Farklı bitler, sayının hangi sınıfa ait olduğunu belirtir.
İşleyiş
rs1 sayısının işaret bitini, üs (exponent) ve mantissa (fraction) değerlerini ayrıştırır.

Her zaman girdileri takip ederek ve değiştiklerinde çalışarak (always @(sign, exp, frac)), sayıyı sınıflandırmak için çeşitli kontroller yapar.

Kontroller ve karşılık gelen sınıflandırmalar:

Eğer üs (exponent) 8'b11111111 ise:

Mantissa'nın ilk biti 1 ise: Quiet NaN (Sessiz NaN)
Mantissa 0 değilse (ilk bit 0): Signaling NaN (Uyarı NaN)
Mantissa 0 ve işaret biti 1 ise: Negative Infinity (Negatif Sonsuz)
Mantissa 0 ve işaret biti 0 ise: Positive Infinity (Pozitif Sonsuz)
Eğer üs (exponent) 8'b00000000 ise:

Mantissa 0 ve işaret biti 1 ise: Negative Zero (Negatif Sıfır)
Mantissa 0 ve işaret biti 0 ise: Positive Zero (Pozitif Sıfır)
Mantissa 0 değilse ve işaret biti 1 ise: Negative Subnormal (Negatif Altnormal)
Mantissa 0 değilse ve işaret biti 0 ise: Positive Subnormal (Pozitif Altnormal)
Diğer durumlarda (normal sayılar):

İşaret biti 1 ise: Negative Normal (Negatif Normal)
İşaret biti 0 ise: Positive Normal (Pozitif Normal)
Özet
Bu modül, verilen kayan nokta sayısını IEEE 754 formatına göre sınıflandırır ve bu sınıflandırmayı rd adlı 10-bit'lik bir çıkışa yazar. Çıkış maskesi, sayının hangi kategoriye ait olduğunu belirlemek için kullanılır.