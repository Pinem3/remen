import 'dart:svg';

import 'package:remen/remen.dart' as remen;
import 'dart:math';
import 'dart:io';

int round_to_nearest(double num) {
  int closest = (num * 1000) as int;
  if (closest % 1000 >= 555) {
    return round_to_nearest(num + 0.5);
  } else {
    return round_to_nearest(num - 0.5);
  }
}

void main(List<String> arguments) {
  print('Введите количество зубьев на ведущей шестерне');
  int z = stdin.readLineSync() as int;
  print('Введите требуемую мощность на быстроходном валу Р (кВт)');
  double P = stdin.readLineSync() as double;
  print('Введите круговую частоту вращения на быстроходном валу мин^(-1)');
  double n = stdin.readLineSync() as double;
  print('Введите передаточное число ременной передачи');
  double i = stdin.readLineSync() as double;
  double m = 3.5 * pow((1000 * P) / n, 1 / 3);
  print('m = 3.5 * (1000 * $P/$n)^(1/3) = ${m.toStringAsFixed(4)}');

  const List listM = [
    [
      1,
      3.1,
      1.0,
      0.8,
      1.6,
      0.4,
      50,
      [40, 160],
      [3, 16]
    ],
    [
      1.5,
      4.71,
      1.5,
      1.2,
      2.2,
      0.4,
      50,
      [40, 160],
      [3, 16]
    ],
    [
      2,
      6.28,
      1.8,
      1.5,
      3.0,
      0.6,
      50,
      [40, 160],
      [5, 20]
    ],
    [
      3,
      9.42,
      3.2,
      2.0,
      4.0,
      0.6,
      40,
      [40, 160],
      [12.5, 50]
    ],
    [
      4,
      12.57,
      4.4,
      2.5,
      5.0,
      0.8,
      40,
      [48, 250],
      [20, 100]
    ],
    [
      5,
      15.71,
      5.0,
      3.5,
      6.5,
      0.8,
      40,
      [48, 250],
      [25, 100]
    ],
    [
      7,
      21.99,
      8.0,
      6.0,
      11.0,
      0.8,
      40,
      [56, 140],
      [40, 125]
    ],
  ];

  int constM = 0;
  for (int i = 1; i < listM.length; i++) {
    if (round_to_nearest(m) <= listM[i][0]) {
      m = listM[i][0];
      constM = i;
      break;
    }
  }
  if (constM == 0) {
    constM = 1;
  }
  List main_settings = [
    [1, 13, 100, 7.7, 2.5, 2, 7, 14],
    [1.5, 10, 100, 10, 3.5, 2.5, 8, 13],
    [2, 10, 115, 11.5, 5, 3.0, 9, 13],
    [3, 10, 115, 12.0, 9, 4.0, 14, 13],
    [4, 15, 120, 8, 25, 6.0, 6, 13],
    [5, 15, 120, 8, 30, 7.0, 8, 13],
    [7, 18, 120, 5.7, 32, 8, 11, 13],
  ];

  int z_1 = z;
  int z_2 = round_to_nearest(z_1 * i);
  int d_1 = round_to_nearest(m * z_1);
  int d_2 = round_to_nearest(m * z_2);
  print('Количество зубьев:\nz_ш = $z_1\nz_к = $z_2\nДиаметр:\n d_ш = $d_1\nd_к = $d_2');
  var p = listM[constM][1];
  print('Шаг ремня: $p');
  var a_min = 0.5 * (d_1 + d_2) + ((Random().nextDouble() + 2) * m);
  print('Предварительное межосевое расстояние: ${a_min.toStringAsFixed(4)}');
  double lp =
      (2 * a_min / p) + (z_1 + z_2) / 2.0 + pow((z_2 - z_1) / (2 * 3.1415926535), 2) * p / a_min;
  List<double> lStandart = [
    45,
    48,
    50,
    53.5,
    56,
    60,
    63,
    67,
    71,
    75,
    80,
    85,
    90,
    100,
    105,
    112,
    115,
    125,
    130,
    140,
    150,
    160,
    170,
    180,
    190,
    200,
    210,
    220,
    235
  ];
  double lRes = 0;
  for (int i = 1; i < lStandart.length; i++) {
    if (lp < lStandart[i]) {
      lRes = lStandart[i];
      break;
    }
  }
  var aRes = p /
      4 *
      (lp -
          (z_2 - z_1) / 2.0 +
          sqrt(((pow(lp - (z_2 - z_1) / 2.0, 2) - 8 * pow((z_2 - z_1) / (2 * pi), 2)))));
  var alp1 = 180 - (57 * (d_2 - d_1) / aRes);
  var z_0 = z_1 * alp1 / 360.0;
  if (z_0 < 6) {}
  var v = (pi * d_1 * n) / 60000.0;
  var T = (30 * P * 1000) / (pi * n);
  var fT = (2 * T * 1000) / d_1;

  var f_0 = main_settings[constM][4];
  var q = main_settings[constM][5] / 1000.0;
  var cp = 1.4;

  var f = f_0 / cp - q * pow(v, 2);
  var b__ = fT / f;
  List cStand = [
    [8, 0.7],
    [16, 0.85],
    [24.99999, 0.95],
    [25, 1],
    [40, 1.1],
    [65, 1.15],
    [100, 1.1],
    [101, 1.15]
  ];
  var cb = 0;
  for (int i = 0; i < cStand.length; i++) {
    if (cStand[i][0] > b__) {
      cb = cStand[i][1];
      break;
    }
  }
  var b = b__ / cb;
  List bStand = [5, 8, 10, 12.5, 16, 20, 25, 32, 40, 50, 63, 80, 100, 125, 160, 200];
  for (int i = 1; i < bStand.length; i++) {
    if (bStand[i] > b) {
      cb = bStand[i];
      break;
    }
  }
  if (listM[constM][8][0] > b) {
    b = listM[constM][8][0];
  }
  List fYList = [
    [2, 1],
    [3, 1.5],
    [4, 4],
    [5, 5],
    [7, 6]
  ];
  var fY = 0;

  for (int i = 1; i < fYList.length; i++) {
    if (fYList[i][0] >= m) {
      fY = fYList[i][1];
      break;
    }
  }
  var f00 = fY * b + q * b * pow(v, 2);
  var fN = 1.1 * fT;
  var da1 = d_1 - 2 * listM[constM][5] + (0.2 * main_settings[constM][6] * 0.0001 * fT * z_1 / b);
  var da2 = d_2 - 2 * listM[constM][5] + (0.2 * main_settings[constM][6] * 0.0001 * fT * z_2 / b);

  var b1 = b + m;
  List hSList = [
    [2, 2.2],
    [3, 3],
    [4, 4],
    [5, 5],
    [7, 8.5]
  ];
  var hS = 0;
  for (int i = 0; i < hSList.length; i++) {
    if (m <= hSList[i][0]) {
      hS = hSList[i][1];
      break;
    }
  }
  var pS1 = pi * (da1 - hS) / z_1;
  var pS2 = pi * (da1 - hS) / z_1;
}
