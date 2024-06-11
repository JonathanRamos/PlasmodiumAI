# A transfer learning approach to identify *Plasmodium* in microscopic images

*Plasmodium* parasites cause Malaria disease; *P. falciparum* and *P. vivax* remain the two main malaria species affecting humans. Identifying the malaria disease in blood smears requires years of expertise, even for highly trained specialists. 

In this work, we assess the transfer learning approach by using well-known pre-trained deep learning architectures. 

We considered 2 database:
  1. 6222 Region of Interest (ROI), of which 6002 are from the Broad Bioimage Benchmark Collection (BBBC);
     - Folder [Datasets/BBBC/Exams](../../tree/master/Datasets/Exams/BBBC)
     - Source https://bbbc.broadinstitute.org/BBBC041
  3. 220 Region of interest were acquired locally by us at Fundaãoo Oswaldo Cruz (FIOCRUZ) in Porto Velho Velho, Rondônia - Brazil, which is part of the legal Amazon.
     -  Folder [Datasets/FIOCRUZ/Exams ](../../tree/master/Datasets/Exams/FIOCRUZ)
  
We exhaustively cross-validated the dataset using 100 distinct [Partitions](../../tree/master/Partitions) with 80% train and 20% test for each considering circular ROIs (rough segmentation), as presented in the following workflow:
![image](https://github.com/JonathanRamos/PlasmodiumAI/assets/3834596/54e31882-c9e0-4bc2-bac2-249d56e33187)



Our experimental results show that DenseNet201 has a potential to identify Plasmodium parasites in ROIs (infected or uninfected) of microscopic images, achieving 99.41% AUC with a fast processing time, as shown in the next figure: 
![image](https://github.com/JonathanRamos/PlasmodiumAI/assets/3834596/9fe06198-1c39-4ff3-9016-7d8b3dc3ce84)



We further validated our results, showing that DenseNet201 was significantly better (99% confidence interval) than the other networks considered in the experiment. 

 In Future work, we intend to scale our approach by adding more data and developing a friendly user interface for CAD use. 
 We aim at aiding the worldwide population and our local natives living nearby the legal Amazon's rivers

**If you use any part of this repository, please cite:**

```
Ramos, et al. A transfer learning approach to identify *Plasmodium* in microscopic images. Journal here, 2024.
```

We made avaiable all our codes, datasets and results as follows:
- [Algorithms and codes](../../tree/master/Codes)
- [Image Datasets](../../tree/master/Datasets)
- [Results](../../tree/master/Metrics)



