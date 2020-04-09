---
title:  'Analiza metod detekcji anomalii na podstawie przebiegu kursów instrumentów finansowych'
author:
- name: Eryk Warchulski
  footnote: 1
- name: Aleksandra Dzieniszewska
  footnote: 1
affiliation:
- number: 1
  name: ewarchul@gmail.com 
- number: 2
  name: aledzienisz@gmail.com 
keyword:
  - latex
  - markdown
abstract: |
  xD
  linenumbers: true
bibliography: biblio.bib
---

# Wprowadzenie

  Celem niniejszego dokumentu jest przedstawienie wstępnych założeń
  dotyczących realizacji projektu analizy algorytmów detekcji anomalii w szeregach czasowych, tj. TSAD (z ang. __time series anomaly detection__).
  W jego ramach zostanie omówiona domena problemu, tj. przebiegi wartości instrumentów finansowych na różnych typach rynków, model zjawiska detekcji anomalii oraz plan eksperymentów. Opisane zostaną również metryki jakości uzyskiwanych rozwiązań jak i źródło pozyskiwanych danych.

# Kursy instrumentów finansowych
  
  Przebieg kursów instrumentów finansowych jak na przykład kursów akcji spółek lub indeksów giełdowych jest fundamentem działania inwestorów na rynkach. 
  Jego zachowanie determinuje strategie oraz ryzyko inwestycyjne. 
  W związku z powyższym faktem kursy akcji są szczególnie interesujące 
  nie tylko dla bezpośrednich aktorów rynkowych, ale również ekonomistów 
  lub statystyków, którzy opracowują modele zachowań tych kursów lub rynków w ogólności.
  Współcześnie bardzo dużo uwagi poświęca się zagadnieniom predykcji przyszłych wartości kursów, co stanowi złożony i trudny problem, biorąc pod uwagę
  fakt, że jedna z dominujących teorii rynkowych, tj. EFM (z ang. __efficient-market hypothesis__) uważa za niemożliwe dokonywanie
  przydatnych predykcji [@RandomWalk] przyszłych kursów, a ponadto uznaje się, że rynki finansowe nie są obojętne na predykcje jak np. pogoda [@Sapiens].
  Niemniej jednak problem predykcji przyszłych wartości kursów nie jest jedynym zagadnieniem, które ma praktyczne znaczenie.
  Możliwość odróżnienia niestandardowych fluktuacji kursów i tym samym punktów odstających może stanowić istotną informację dla inwestorów i zaangażować
  dedykowane takim zdarzeniom procesy biznesowe. Szczególnie istotne wydaje się to z punktu widzenia zautomatyzowanych rynków giełdowych, w których 
  akcje podejmowane przez aktorów (systemy decyzyjne) mierzone są w milisekundach, a dane giełdowe mogą być traktowane jako strumieniowe [@HFT-wiki]. Wówczas wykrycie anomalii i jej odpowiednie obsłużenie wydaje się być krytyczne dla gracza rynkowego.

  W ramach realizacji projektu użyte zostaną łącznie 3 zbiory danych, na które składają się przebiegi kursów instrumentów finansowych. Dwa z nich będą pochodzić z rzeczywistych rynków finansowych, a jeden z rynku wirtualnego. 
  Motywacją takiego podejścia jest chęć zaobserwowania zachowania się rynku w świecie, w którym na wartość kursu wpływa bardzo duża liczba czynników jawnych lub niejawnych, oraz w świecie, w którym zbiór możliwych akcji podejmowanych przez aktorów jest znacząco ograniczony oraz sam świat ma raczej charakter statyczny i iteracyjny.


## Rynki rzeczywiste
   

## Rynki wirtualne

# Model detekcji anomalii 

# Algorytmy detekcji anomalii

## STL

## Las izolacyjny

## Metody spektralne

# Plan badań

# Źródła danych









