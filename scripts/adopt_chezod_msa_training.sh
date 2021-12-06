#!/bin/bash 

# Copyright (c) 2021 Peptone.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

# The work directory is </ADOPT> in the <adopt> container
LOCAL_MSA_DIR="../msa"
TRAIN_FASTA_FILE_PATH="datasets/chezod_1325_all.fasta"
TEST_FASTA_FILE_PATH="datasets/chezod_117_all.fasta"
TRAIN_RES_REPR_DIR_PATH="representations/chezod_1325"
TEST_RES_REPR_DIR_PATH="representations/chezod_117"
TRAIN_STRATEGY="<training_strategy>" # choose a training strategy
TRAIN_JSON_FILE_PATH="datasets/1325_dataset_raw.json"
TEST_JSON_FILE_PATH="datasets/117_dataset_raw.json" 

printf "Setting up the MSA procedure \n"
bash scripts/adopt_msa_setup.sh $LOCAL_MSA_DIR

printf "Extracting Multi Sequence Alignments of %s \n" $TRAIN_FASTA_FILE_PATH
bash scripts/msa_generator.sh $TRAIN_FASTA_FILE_PATH

printf "Extracting Multi Sequence Alignments of %s \n" $TEST_FASTA_FILE_PATH
bash scripts/msa_generator.sh $TEST_FASTA_FILE_PATH

printf "Extracting residue level representations of %s \n" $TRAIN_FASTA_FILE_PATH
docker exec -it adopt python adopt/embedding.py fasta_path $TRAIN_FASTA_FILE_PATH \
                                                repr_dir $TRAIN_RES_REPR_DIR_PATH \
                                                --msa

printf "Extracting residue level representations of %s \n" $TEST_FASTA_FILE_PATH
docker exec -it adopt python adopt/embedding.py fasta_path $TEST_FASTA_FILE_PATH \
                                                repr_dir $TEST_RES_REPR_DIR_PATH \
                                                --msa

printf "Training ADOPT on %s \n" $TRAIN_FASTA_FILE_PATH
docker exec -it adopt python adopt/training.py train_strategy $TRAIN_STRATEGY \
                                               train_json_file $TRAIN_JSON_FILE_PATH \
                                               test_json_file $TEST_JSON_FILE_PATH \
                                               train_repr_dir $TRAIN_RES_REPR_DIR_PATH \
                                               test_repr_dir $TEST_RES_REPR_DIR_PATH \
                                               --msa

docker cp adopt:/ADOPT/models .
printf "The trained models have been stored in ./models"