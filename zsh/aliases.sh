# allow sudo command to use aliases
alias sudo='sudo '

alias ls='ls -G'
alias la='ls -laG'
alias ll='ls -la'

alias watch='watch '

alias v='nvim '
alias i.='(idea $PWD &>/dev/null &)'
alias c.='(code $PWD &>/dev/null &)'
alias o.='open .'

alias dotfiles="cd ~/.dotfiles"

alias cat=bat

# kubernetes aliases
alias k=kubectl
alias kaf='kubectl apply -f'
alias keti='kubectl exec -ti'
alias kdel='kubectl delete'
alias kdelf='kubectl delete -f'
alias kgp='kubectl get pods'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='kubectl edit pod'
alias kdp='kubectl describe pod'
alias kdelp='kubectl delete pod'
alias kgpl='kgp -l'
alias kgs='kubectl get service'
alias kes='kubectl edit service'
alias kds='kubectl describe service'
alias kdels='kubectl delete service'
alias kgi='kubectl get ingress'
alias kei='kubectl edit ingress'
alias kdi='kubectl describe ingress'
alias kdeli='kubectl delete ingress'
alias kgns='kubectl get namespaces'
alias kens='kubectl edit namespace'
alias kdns='kubectl describe namespace'
alias kdelns='kubectl delete namespace'
alias kgcm='kubectl get configmaps'
alias kecm='kubectl edit configmap'
alias kdcm='kubectl describe configmap'
alias kdelcm='kubectl delete configmap'
alias kgsec='kubectl get secrets'
alias kdsec='kubectl describe secret'
alias kdelsec='kubectl delete secret'
alias kgd='kubectl get deployments'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='kubectl edit deployment'
alias kdd='kubectl describe deployment'
alias kdeld='kubectl delete deployment'
alias ksd='kubectl scale deployment'
alias krsd='kubectl rollout status deployment'
alias kpf="kubectl port-forward"
alias kga='kubectl get all'
alias kgaa='kubectl get all --all-namespaces'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kgno='kubectl get nodes'
alias kdno='kubectl describe node'
alias kdelno='kubectl delete node'

# maven
alias mvncie='mvn clean install eclipse:eclipse'
alias mvnci='mvn clean install'
alias mvncist='mvn clean install -DskipTests'
alias mvncisto='mvn clean install -DskipTests --offline'
alias mvne='mvn eclipse:eclipse'
alias mvnce='mvn clean eclipse:clean eclipse:eclipse'
alias mvncv='mvn clean verify'
alias mvnd='mvn deploy'
alias mvnp='mvn package'
alias mvnc='mvn clean'
alias mvncom='mvn compile'
alias mvnct='mvn clean test'
alias mvnt='mvn test'
alias mvnag='mvn archetype:generate'
alias mvn-updates='mvn versions:display-dependency-updates'
alias mvntc7='mvn tomcat7:run'
alias mvntc='mvn tomcat:run'
alias mvnjetty='mvn jetty:run'
alias mvnboot='mvn spring-boot:run'
alias mvndt='mvn dependency:tree'
alias mvns='mvn site'
alias mvnsrc='mvn dependency:sources'
alias mvndocs='mvn dependency:resolve -Dclassifier=javadoc'

# git
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcm='git checkout $(git_main_branch)'
alias gd='git diff'
alias gdca='git diff --cached'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'
alias gpr='git pull --rebase'
alias gsb='git status -sb'
alias gsw='git switch'
alias gswc='git switch -c'
alias grebasei='git rebase -i `gcshow`'
alias grs='git restore'
