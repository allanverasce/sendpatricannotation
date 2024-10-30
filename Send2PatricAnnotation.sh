#!/bin/bash

# Variáveis de login e configuração
username="seuUsuário"
password="suaSenha"
fasta_dir="Caminho completo... exemplo /home/allan/fasta_files"    # Diretório com arquivos FASTA
taxonomy_id=562                         # ID taxonômico (exemplo: Ecoli), podes pegar no site https://www.ncbi.nlm.nih.gov/taxonomy
description="Bacteria"
output_dir="home"
jobs_file="jobs_list"                   # Arquivo que armazenará IDs dos jobs

# Função para login
login() {
    echo "Realizando login..."
    login_output=$(p3-login "$username" "$password")
    echo "$login_output"
    
    # Extrair o email completo do username
    user_email=$(echo "$login_output" | grep -oP '(?<=Logged in with username ).*')
    if [ -z "$user_email" ]; then
        echo "Erro: Não foi possível capturar o email do usuário no login."
        exit 1
    fi
    echo "Usuário logado: $user_email"
}

# Função para submeter cada arquivo FASTA para anotação
submit_jobs() {
    echo "Submetendo arquivos para anotação..."
    > "$jobs_file"  # Limpar ou criar arquivo jobs_list, é importante pois aqui esta o controle de submissão

    for contigs_file in "$fasta_dir"/*.fasta; do
        # Nome do projeto baseado no nome do arquivo (sem extensão), foi a melhor forma para poder baixar depois
        project_name=$(basename "$contigs_file" .fasta)
        
        # Submeter arquivo para anotação
        submit_output=$(p3-submit-genome-annotation -f --contigs-file "$contigs_file" -t "$taxonomy_id" -d "$description" "/$user_email/$output_dir" "$project_name")
        echo "$submit_output"
        
        # Extrair o ID da submissão e salvar com o nome do projeto
        submission_id=$(echo "$submit_output" | grep -oP '(?<=Submitted annotation with id )\d+')
        if [ -z "$submission_id" ]; then
            echo "Erro: Não foi possível capturar o ID da submissão para o arquivo $contigs_file."
        else
            echo "$submission_id $project_name" >> "$jobs_file"
            echo "Submissão realizada para o projeto '$project_name' com ID $submission_id"
        fi
    done
}

# Função para monitorar o status de todos os jobs até estarem finalizados
monitor_jobs() {
    echo "Monitorando o status dos jobs..."
    while true; do
        all_done=true
        for job in $(cut -d ' ' -f2 "$jobs_file"); do
            if ! p3-ls -l --type "/$user_email/$output_dir/$job" | grep -q "job_result"; then
                echo "Job '$job' ainda em processamento. Aguardando..."
                all_done=false
            else
                echo "Job '$job' finalizado."
            fi
        done

        # Se todos os jobs estiverem finalizados, sair do loop
        if $all_done; then
            break
        fi
        sleep 60  # Espera de 1 minuto antes de checar novamente
    done
}

# Função para baixar os resultados dos jobs finalizados
retrieve_jobs() {
    echo "Baixando resultados dos jobs..."
    mkdir -p genbank
    
    # Ler arquivo jobs_list para baixar cada job
    while read -r submission_id project_name; do
        echo "Baixando resultado do projeto '$project_name' (ID: $submission_id)..."
        
        # Caminho completo do arquivo .gb
        p3-cp ws:"/$user_email/$output_dir/.$project_name/$project_name.gb" "genbank/$project_name.gb"
        
        # Verifica se o download foi bem-sucedido
        if [ $? -eq 0 ] && [ -f "genbank/$project_name.gb" ]; then
            echo "Arquivo $project_name.gb baixado com sucesso para a pasta genbank/"
        else
            echo "Erro ao baixar o arquivo $project_name.gb"
        fi
    done < "$jobs_file"
}

# Chamando as funções kkkkk vai garotas .........
login
submit_jobs
monitor_jobs
retrieve_jobs
p3-logout
echo "Pronto acabou. Tchauuuuu........."

