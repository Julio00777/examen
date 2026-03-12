FROM python:3.11-slim-bookworm

# Création d'un utilisateur système non-root pour la sécurité
RUN useradd -m -r taskflow_user

WORKDIR /app

# On copie d'abord uniquement les requirements pour utiliser le cache Docker
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Ensuite, on copie le reste du code de l'application
COPY . .

# On donne les droits au nouvel utilisateur
RUN chown -R taskflow_user:taskflow_user /app

# On bascule sur l'utilisateur sécurisé
USER taskflow_user

EXPOSE 5000

# Commande de lancement avec Gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
