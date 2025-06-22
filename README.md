# Heart Data Analysis Expert System

This project is an expert system designed for analyzing heart disease datasets using fuzzy logic and rule-based inference. It combines rule files for the [CLIPS](http://www.clipsrules.net/) expert system environment with data processed via [WEKA](https://www.cs.waikato.ac.nz/ml/weka/) to generate insightful predictions and reasoning paths.

## 🧠 Overview

* Utilizes fuzzy logic rules to mimic human reasoning in diagnosing heart conditions.
* Built with CLIPS, with both standard and optimized rule versions.
* Integrates datasets and models generated from WEKA for training and testing.

## 📁 Project Structure

```
.
├── README.md                  # Project overview and instructions
├── clips/                     # CLIPS rule files and inputs
│   ├── fuzzyclips.clp         # Core fuzzy inference engine
│   ├── fuzzyclips-optimized.clp
│   ├── rules.clp              # Base rule set
│   ├── rules-optimized.clp    # Enhanced/optimized rules
│   ├── metrics.clp            # Evaluation metrics computation
│   ├── input/
│   │   ├── input-training-set.clp
│   │   └── input-test-set.clp # CLIPS-readable datasets
│   └── rules.txt              # Human-readable version of rules
├── img/
│   └── decision-tree.png      # Decision tree visualization
└── weka/
    ├── heart.arff             # Full dataset in ARFF format
    ├── heart-train.arff       # Training split
    ├── heart-test.arff        # Testing split
    └── heart.csv              # Original dataset in CSV format
```

## 🚀 How to Run

1. **Install CLIPS**
   Download and install CLIPS from [here](http://www.clipsrules.net/).

2. **Load a Fuzzy Engine**
   Open CLIPS and load the fuzzy logic system:

   ```clips
   (load "clips/fuzzyclips.clp")
   ;; or
   (load "clips/fuzzyclips-optimized.clp")
   ```

3. **Load Rules and Input**
   Load a rule set and a dataset:

   ```clips
   (load "clips/rules.clp")
   (load "clips/input/input-test-set.clp")
   (reset)
   (run)
   ```

4. **Review Output**
   The system will evaluate input cases using fuzzy logic and output the inference trace and results.

## 📊 Dataset Details

* Sourced from a standard heart disease dataset.
* Attributes include age, sex, blood pressure, cholesterol, heart rate, etc.
* Preprocessed using WEKA into `.arff` and `.clp` formats.

## 📈 Visualization

The `img/decision-tree.png` shows the structure of the decision tree used in early stages of rule extraction or analysis, helping visualize attribute importance and rule paths.

## 🧪 Testing & Evaluation

* `metrics.clp` computes diagnostic metrics such as accuracy, precision, and recall.
* Compare rule effectiveness by running both base and optimized rule files.

## 📚 References

* CLIPS: A Tool for Building Expert Systems — [clipsrules.net](http://www.clipsrules.net/)
* WEKA: Data Mining Software in Java — [weka.sourceforge.net](https://weka.sourceforge.net/)

