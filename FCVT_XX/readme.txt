Bu modül, bir IEEE 754 formatında tek hassasiyetli (single-precision) kayan nokta sayısını, işaretsiz veya işaretli bir tamsayıya ya da tersi bir şekilde dönüştürür. Hangi dönüşümün yapılacağı conv_type_i girişi ile belirlenir.

Girdiler
a_i: 32-bit'lik giriş değeri (kayan nokta veya tamsayı).
op_signed_i: Girdi veya çıktı tamsayının işaretli (signed) olup olmadığını belirler.
conv_type_i: Dönüşüm türünü belirler. 1 ise tamsayıdan kayan nokta sayısına, 0 ise kayan nokta sayısından tamsayıya dönüşüm yapılır.
Çıkış
result: 32-bit'lik dönüşüm sonucu.
İşleyiş
Kayan Noktadan Tamsayıya Dönüşüm (FCVT.W.S ve FCVT.WU.S)
a_i girişinin bileşenleri (işaret biti, üs ve mantissa) ayrıştırılır.
Üs değeri 127'den küçükse expo_is_low sinyali aktif olur ve sayı 0'a atanır.
Üs değeri ve işaret bitine bağlı olarak aşma durumu (overflow) kontrol edilir.
Mantissa uygun miktarda kaydırılarak tamsayı değeri hesaplanır.
Aşma durumunda işaretli tamsayı için maksimum/minimum değer, işaretsiz tamsayı için maksimum değer atanır.
Tamsayıdan Kayan Noktaya Dönüşüm (FCVT.S.W ve FCVT.S.WU)
Giriş tamsayı değeri a_i, iki'nin tümleyeni formuna dönüştürülür (işaretli ise).
Giriş tamsayı değeri sıfır ise, sonuç sıfır olarak atanır.
Giriş tamsayı değerinin kaç basamak sola kaydırılması gerektiğini hesaplamak için uygun bitler kontrol edilir.
Tamsayı değeri normalleştirilir ve bu normalleştirilmiş değerden mantissa ve üs hesaplanır.
Mantissa ve üs, işaret biti ile birleştirilerek sonuç olarak atanır.
Dönüşüm Türü Seçimi
conv_type_i sinyaline göre dönüşüm türü seçilir.
conv_type_i = 1 ise: Tamsayıdan kayan noktaya dönüşüm yapılır.
conv_type_i = 0 ise: Kayan noktadan tamsayıya dönüşüm yapılır.
Özet
Bu modül, verilen 32-bit'lik giriş değerini, işaretli veya işaretsiz tamsayıdan tek hassasiyetli kayan nokta sayısına veya tersi bir şekilde dönüştürür. Hangi dönüşümün yapılacağı conv_type_i sinyali ile belirlenir ve sonuç result çıkışında elde edilir.