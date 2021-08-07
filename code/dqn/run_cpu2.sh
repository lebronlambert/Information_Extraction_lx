#!/usr/bin/env bash


if [ -z "$1" ]
  then echo "Please provide the port for the game, e.g.  ./run_cpu 5050 "; exit 0
fi
FRAMEWORK="alewrap"
exp_folder=$2
# exp_folder="logs/tmp2_shooter_newagg/"
game_path=$PWD"/roms/"
env_params="useRGB=true"
agent="NeuralQLearner"
n_replay=1

netfile="\"network_mass\""
# netfile="\"logs/tmp2/agent_5051.t7\""
# netfile="\"logs/tmp2_2/agent_5050.t7\""
minibatch_size=100
update_freq=1
actrep=1 #TODO: check this
discount=${3:-0.8}
seed=1
learn_start=${4:-12500} #-50000}
pool_frms_type="\"max\""
pool_frms_size=2
initial_priority="false"
replay_memory=2500 #5000
eps_end=0.1
eps_endt=$replay_memory
lr=${5:-0.000025}
lr_end=0.000025
lr_endt=$replay_memory
wc=0.0
agent_type="DQN3_0_1"
agent_name="agent_"$1
ncols=1
target_q=${6:-1250} #-5000}
mode='Shooter'
if [ "$mode" == "Shooter" ]
then
    state_dim=56;
    n_queries=2;
else
    state_dim=31;
    n_queries=4;
fi;

agent_params="n_queries="$n_queries",wc="$wc",lr="$lr",lr_end="$lr_end",lr_endt="$lr_endt",ep=1,ep_end="$eps_end",ep_endt="$eps_endt",discount="$discount",hist_len=1,learn_start="$learn_start",replay_memory="$replay_memory",update_freq="$update_freq",n_replay="$n_replay",network="$netfile",state_dim="$state_dim",minibatch_size="$minibatch_size",rescale_r=1,ncols="$ncols",bufferSize=512,valid_size=500,target_q="$target_q",clip_delta=10,min_reward=-10,max_reward=10"
steps=50000 #200000 #200000
eval_freq=2500 #10000
eval_steps=2500 #5000
prog_freq=2500 #10000
save_freq=2500 #10000
gpu=-1
random_starts=0
pool_frms="type="$pool_frms_type",size="$pool_frms_size
num_threads=4

args="-mode $mode -exp_folder $exp_folder -zmq_port $1 -framework $FRAMEWORK -game_path $game_path -name $agent_name -env_params $env_params -agent $agent -agent_params $agent_params -steps $steps -eval_freq $eval_freq -eval_steps $eval_steps -prog_freq $prog_freq -save_freq $save_freq -actrep $actrep -gpu $gpu -random_starts $random_starts -pool_frms $pool_frms -seed $seed -threads $num_threads"
echo $args

cd dqn
mkdir -p $exp_folder;
OMP_NUM_THREADS=1 th train_agent.lua $args


#mode Shooter -exp_folder tmp/ -zmq_port 7000 -framework alewrap -game_path /home/miss-iris/Desktop/code_all/DeepRL-InformationExtraction-master/code/dqn/roms/ -name agent_7000 -env_params useRGB=true -agent NeuralQLearner -agent_params n_queries=5,wc=0.0,lr=0.000025,lr_end=0.000025,lr_endt=500000,ep=1,ep_end=0.1,ep_endt=500000,discount=0.8,hist_len=1,learn_start=50000,replay_memory=500000,update_freq=1,n_replay=1,network="network_mass",state_dim=41,minibatch_size=100,rescale_r=1,ncols=1,bufferSize=512,valid_size=500,target_q=5000,clip_delta=10,min_reward=-10,max_reward=10 -steps 2000000 -eval_freq 10000 -eval_steps 5000 -prog_freq 10000 -save_freq 10000 -actrep 1 -gpu -1 -random_starts 0 -pool_frms type="max",size=2 -seed 1 -threads 4
