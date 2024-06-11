# A transfer learning approach to identify *Plasmodium* in microscopic images

*Plasmodium* parasites cause Malaria disease; *P. falciparum* and *P. vivax* remain the two main malaria species affecting humans. Identifying the malaria disease in blood smears requires years of expertise, even for highly trained specialists. 

In this work, we assess the transfer learning approach by using well-known pre-trained deep learning architectures. 

We considered 2 database:
  1. 6222 Region of Interest (ROI), of which 6002 are from the Broad Bioimage Benchmark Collection (BBBC),
  2. 220 Region of interest were acquired locally by us at Fundaãoo Oswaldo Cruz (FIOCRUZ) in Porto Velho Velho, Rondônia - Brazil, which is part of the legal Amazon. 
  
We exhaustively cross-validated the dataset using 100 distinct partitions with 80% train and 20% test for each considering circular ROIs (rough segmentation). 

Our experimental results show that DenseNet201 has a potential to identify Plasmodium parasites in ROIs (infected or uninfected) of microscopic images, achieving 99.41% AUC with a fast processing time. 


We further validated our results, showing that DenseNet201 was significantly better (99% confidence interval) than the other networks considered in the experiment. Our results support claiming that transfer learning with texture features potentially differentiates subjects with malaria, spotting those with Plasmodium even in Leukocytes images, which is a challenge. In Future work, we intend scale our approach by adding more data and developing a friendly user interface for CAD use. We aim at aiding the worldwide population and our local natives living nearby the legal Amazon's rivers

**If you use any part of this repository, please cite:**

```
Ramos, et al. FA transfer learning approach to identify *Plasmodium* in microscopic images. Journal here, 2024.
```

We made avaiable all our codes, datasets and results as follows:
- [Algorithms and codes](Codes/OldMatlab)
- [Image Datasets](ImageDatasets)
- [Results](Results)




## Results

Results considering each anatomical group available at: [Muscles](PM/readme.md), [Discs](IVD/readme.md), and [Vertebrae](VBs/readme.md).

Here, we present the overall results as follows: 


### Results Without EANIS

Figure 2: Example of annotations. 
![image](https://user-images.githubusercontent.com/3834596/185267331-a82065f1-4d17-4549-8d09-4431d59949ad.png)

Figure 3: Overall results comparison
![image](https://user-images.githubusercontent.com/3834596/185266101-82bed07e-3745-40f5-a385-a3c9d2301871.png)


Figure 4: Segmentation Results Comparison.
![image](https://user-images.githubusercontent.com/3834596/185318153-70e867fb-b690-405c-9a15-48c32c5831c0.png)



