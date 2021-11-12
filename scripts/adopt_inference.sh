#!/bin/bash   

NEW_PROT_FASTA_FILE_PATH="<new_proteins_fasta_file_path>"
NEW_PROT_RES_REPR_DIR_PATH="<new_proteins_residue_level_representation_dir>"
TRAIN_STRATEGY="<training_strategy>"
MODEL_TYPE="<model_type>"
PRED_Z_FILE_PATH="<predicted_z_scores_file>"

python embedding.py -f $NEW_PROT_FASTA_FILE_PATH 
                    -r $NEW_PROT_RES_REPR_DIR_PATH

printf "Extracting the residue level representation of new proteins"

python inference.py -s $TRAIN_STRATEGY 
                    -m $MODEL_TYPE 
                    -f $NEW_PROT_FASTA_FILE_PATH 
                    -r $NEW_PROT_RES_REPR_DIR_PATH 
                    -p $PRED_Z_FILE_PATH

printf "Computing Z scores of new proteins"