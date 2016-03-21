## 1. Introducere
### 1.1 Contextul proiectului
  [https://en.wikipedia.org/wiki/Artificial_neural_network#Background]

  Rețelele neuronale artificiale (RNA, în engleză: *artificial neural networks - ANN*) reprezintă un model computațional inspirat din rețelele neuronale biologice (cum ar fi sistemul nervos central, în special creierul) și sunt folosite, în general, pentru a estima funcții care au un număr mare de intrări și cu complexitate ridicată. Reprezintă o ramură a inteligenței artificiale, mai precis sunt sisteme de *machine learning*, adică învață din seturi de date, de aceea se pretează la aplicații de tip procesare de imagini (*image processing*), recunoaștere de forme (*pattern recognition*), recunoaștere și procesare de limbaj natural (*speech recognition*), ș.a.m.d., în special acolo unde soluția problemei nu se poate formula folosind algoritmi clasici, ci trebuie dedusă, "învățată" din seturile de date disponibile.

  La nivel structural, rețelele neuronale artificiale sunt alcătuite din *neuroni artificiali*, modele matematice ale celor biologici. Neuronul biologic, unitatea fundamentală a sistemului nervos, este alcătuit din:
  * __Arborele dendritic__ care colectează semnalele de intrare de la alți neuroni
  * __Soma__ care procesează semnalele de intrare și generează semnalele de ieșire
  * __Axonul__ care transmite semnalele de ieșire către alți neuroni
 [http://cs.upm.ro/_users/calin.enachescu/Enachescu%20-%20Inteligenta%20artificiala/Curs/Cartea%20v21.pdf]

Neuronii sunt interconectați prin intermediul unor legături numite *__sinapse__*, iar comunicarea se realizează prin intermediul unor semnale electrice numite *__impulsuri__*. Fiecare sinapsă are o valoare de prag (*threshold*), care determină activarea sau inhibarea neuronului post-sinaptic. Acest nivel de activare se poate modifica și reprezintă un mecanism de învățare (memorare) biologic.

Intervalul de timp dintre momentul emisiei unui semnal la soma neuronului pre-sinaptic şi momentul emisiei unui semnal indus de către neuronul post-sinaptic, este de aproximativ 1-2 msec. Comparativ cu un dispozitiv electronic artificial, acest interval de timp este de până la 6 ordine de mărime mai mare. Totuși, d.p.d.v. al puterii de calcul, sistemul biologic (creierul) este net superior oricărui sistem electronic, de unde se poate deduce că aceasta se obține prin interconectarea masivă a unui număr mare de elemente de procesare relativ lente (spre exemplu, creierul uman este alcătuit din aproximativ 10<sup>11</sup> neuroni, iar fiecare neuron este interconectat cu alți 10<sup>4</sup> neuroni).

Într-o reţea neuronală artificială, unitatea analogă neuronului biologic este o unitate de procesare simplă, care va fi numit neuron artificial. Acesta are mai multe intrări, corespunzând arborelui dendritic, fiecare intrare fiind ponderată, asemenea valorii de prag a sinapsei biologice. Toate aceste produse se însumează, proces care reprezintă rolul somei din neuronul biologic:
$$y = b + \sum_{i=1}^n x_i * w_i$$
unde termenul *b* se numește *__bias__* și are valoare constantă, finnd folosit pentru ajustarea valorii de prag. Rezultatul obținut reprezintă argumentul *__funcției de activare__*, care va fi valoarea de ieșire a neuronului. Dintre cele mai utilizate funcții de activare, amintim:






## 2. Obiectivele cercetării

## 3. Studiu bibliografic/Stadiul actual în domeniu

## 4. Prezentarea proiectului

## 5. Concluzii
