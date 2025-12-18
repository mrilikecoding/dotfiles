. "$HOME/.cargo/env"

# NON-SECRET vars

# Ollama 
export OLLAMA_HOST=http://127.0.0.1:11434
export OLLAMA_CONTEXT_LENGTH=8192


export EDITOR='nvim'

eval "$(_LLM_ORC_COMPLETE=zsh_source 
  llm-orc completion)"
