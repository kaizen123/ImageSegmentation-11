% Load previously saved params
load('good_params')

% Calculate negative loglikelihood probabilities
[probs, logprobs] = CalculateLikelihoodProbabilities(data, k, kappas, mus);

% Generate starting segmentation
segment_init = randi(k, [Size, Size]);

% Find MAP
[map_gcs, ~] = MRF_MAP_GraphCutABSwap(segment_init, logprobs, 2, k, 10, 4);
[map_gce, ~] = MRF_MAP_GraphCutAExpansion(segment_init, logprobs, 2, k, 10, 4);
[map_icm] = ICM(segment_init, logprobs, k, 2, 50, 4);
[map_sa] = SimulatedAnnealing(segment_init, logprobs, k, 2, 4, 0.6, 100, 4);
map_kmeans = reshape(kmeans(data, k), [Size, Size]);

% Calculate energies
gt = reshape(gt, [Size,Size]);
e_gt = CalculateFinalEnergy(gt, ...
    logprobs, ...
    2, 4);

e_gcs = CalculateFinalEnergy(map_gcs, ...
        logprobs, ...
        2, ...
        4);
e_gce = CalculateFinalEnergy(map_gce,...
        logprobs, ...
        2, ...
        4);
e_icm = CalculateFinalEnergy(map_icm,...
        logprobs, ...
        2, ...
        4);
e_sa = CalculateFinalEnergy(map_sa,...
        logprobs, ...
        2, ...
        4);
 
e_kmeans = CalculateFinalEnergy(map_kmeans,...
        logprobs, ...
        2, ...
        4);

% Calculate Similarity scores
dsc_gcs = SimilarityScore(gt, map_gcs, k);
dsc_gce = SimilarityScore(gt, map_gce, k);
dsc_icm = SimilarityScore(gt, map_icm, k);
dsc_sa = SimilarityScore(gt, map_sa, k);
dsc_kmeans = SimilarityScore(gt, map_kmeans, k);


