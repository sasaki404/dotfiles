#!/bin/bash

# 既存のセッションがある場合は、何もしない
if [ -n "$TMUX" ]; then
  exit 1
fi

tmux kill-session -t mysession
# tmuxセッションを作成する
tmux new-session -d -s mysession

# ウィンドウ1を作成し、NERDTreeを開く
tmux new-window -t mysession:1 -n 'dev'
tmux send-keys -t mysession:1 'nvim' C-m
tmux send-keys -t mysession:1 ':NERDTree ~/dev/' C-m
tmux send-keys -t mysession:1 ':belowright' C-m
tmux send-keys -t mysession:1 ':wincmd w' C-m
# 新しいペインを作成し、atcoder-cppディレクトリに移動する
# tmux split-window -t mysession:1
# tmux send-keys -t mysession:1 'cd ~/dev/atcoder-cpp' C-m
# tmux resize-pane -D 10
# tmux split-window -h
# tmux send-keys -t mysession:1 'cd ~/dev' C-m
# tmux select-pane -t mysession:1.0

# ウィンドウ2を作成し、ビューを開く
tmux new-window -t mysession:2 -n 'memo'
tmux send-keys -t mysession:2 'nvim' C-m
tmux send-keys -t mysession:2 ':NERDTree ~/dev/memo' C-m
tmux send-keys -t mysession:2 ':belowright' C-m
tmux send-keys -t mysession:2 ':wincmd w' C-m

tmux send-keys -t mysession:0 'cd ~/dev' C-m

# 最初のウィンドウに移動する
tmux select-window -t mysession:1

# tmuxセッションにアタッチする
tmux attach-session -t mysession
