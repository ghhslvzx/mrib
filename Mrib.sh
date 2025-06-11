#!/data/data/com.termux/files/usr/bin/bash

# Função: barra de progresso
progress_bar() {
  local total=20
  for ((i = 1; i <= total; i++)); do
    percent=$(( i * 100 / total ))
    done_bar=$(printf '#%.0s' $(seq 1 $i))
    rest_bar=$(printf '*%.0s' $(seq $i $total))
    echo -ne "[$done_bar$rest_bar] $percent% \r"
    sleep 0.07
  done
  echo ""
}

echo ""
echo "🚀 RAM INSTANT BOOST (RIB)"
echo "=============================="
echo "[1] Limpeza leve (RAM cache)"
echo "[2] Limpeza média (RAM + trim)"
echo "[3] Limpeza bruta (mata apps + RAM + trim)"
echo "=============================="
read -p "Escolha a opção [1-3]: " opcao

case $opcao in
  1)
    echo "➤ Limpando RAM cache..."
    progress_bar
    su -c "sync; echo 3 > /proc/sys/vm/drop_caches"
    echo "✅ RAM cache limpa."
    ;;
  2)
    echo "➤ Limpando RAM cache e trim de apps..."
    progress_bar
    su -c "sync; echo 3 > /proc/sys/vm/drop_caches"
    su -c "pm trim-caches 500M" || echo "⚠️ pm trim-caches falhou — ignorando."
    echo "✅ RAM e cache de apps limpos."
    ;;
  3)
    echo "⚠️ AVISO: Essa opção fecha apps em segundo plano (WhatsApp, música, navegador etc)"
    read -p "❓ Tem certeza que quer continuar? [s/N]: " confirm
    if [[ "$confirm" =~ ^[sS]$ ]]; then
      echo "➤ Matando apps em segundo plano..."
      su -c "for pid in \$(ps -A | grep u0_a | awk '{print \$2}'); do kill -9 \$pid; done"
      echo "➤ Limpando RAM e cache..."
      progress_bar
      su -c "sync; echo 3 > /proc/sys/vm/drop_caches"
      su -c "pm trim-caches 1G" || echo "⚠️ pm trim-caches falhou — ignorando."
      echo "✅ Limpeza pesada concluída."
    else
      echo "❌ Cancelado pelo usuário."
    fi
    ;;
  *)
    echo "❌ Opção inválida."
    ;;
esac

# Auto instalação com alias
cp "$0" /data/data/com.termux/files/usr/bin/mrib
chmod +x /data/data/com.termux/files/usr/bin/mrib
echo "[✔] Comando 'mrib' instalado! Agora é só digitar: mrib"
