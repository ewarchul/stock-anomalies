# MOW Projekt

## Dokumentacja Wstępna 
### Detekcja anomalii w szeregach czasowych na danych giełdowych 

Aleksandra Dzieniszewska 
Eryk Warchulski 

## 1. szczegółowa interpretacja tematu projektu
* metody identyfikacji punktów czasu zawierających wartości uznawane za nieprawidłowe
Detekowane będą trendy (anomalie globalne) i lokalne anomalie.
1. Pierwszą metodą będzie STL (series - trend decomposition) - za jej pomocą detekowane będą addytwne anomalie. Do setekcji zmian poziomu zostanie wykorzystana krocząca średnia sygnału zamiast sygnału orginalnego. 
2. Zbadana zostanie metoda k-NN w której, branych pod uwagę jest kpróbek wcześniejszych i k próbek następujących po badanej próbce. W ten spodób zdefiniowane jest okno przetwarzania. Anaomalią jest próbka której, wartość nie zawiera się w przedziale predykowanym na podstawie pozostałych próbek w oknie. 
3. ARIMA - generacja nowego punktu na podstawie punktów poprzednich oraz szumu. 
4. transformata falkowa 
5. transformata fouriera 
* metody transformacji danych do reprezentacji wektorowej przez agregację w oknie czasowym,
przeprowadzone zostanie porównanie okna wykorzystującego próbki wcześniejsze i następujące po próbce badanej oraz okna wykorzystującego tylo próbki wcześniejsze. W metodzie k-nn próbka predykowana jest jako kombinacja liniowa próbek z okna.  
* ustalenia kryteriów lub algorytmu selekcji atrybutów,
* wyboru algorytmów nadzorowanej lub nienadzorowanej detekcji anomalii,
* wskazania parametrów algorytmów wymagających strojenia (ze szczególnym uwzględnieniem parametrów mających wpływ na wrażliwość na anomalie),
rozmiar okna przetwarzania 
* ustalenia procedur i kryteriów oceny jakości detekcji anomalii.

## 2. opis algorytmów, które będą implementowane lub wykorzystane do badań,
## 3. plan badań, w tym:
* cel poszczególnych eksperymentów (pytania, na które będzie poszukiwana odpowiedź, lub hipotezy do weryfikacji),
* charakterystykę zbiorów danych, które będą wykorzystane (oraz ewentualnych czynności związanych z przygotowaniem danych),
Wykorzystane zostaną zbiory danych giełdowych (zmiany cen akcji w czasie) pochodzące z ... . Dane muszą zostać przekształcone do postaci wektorowej. ... 
transformata falkowa 
transformata fouriera (przejście do dziedziny częstotliwości) 
* parametry algorytmów, których wpływ na wyniki będzie badany,
STL - trust interval 
* miary jakości i procedury oceny modeli,
## 4. otwarte kwestie wymagające późniejszego rozwiązania (wraz z wyjaśnieniem powodów, dla których ich rozwiązanie jest odłożone na później).
