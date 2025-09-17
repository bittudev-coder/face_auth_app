FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential cmake \
    libopenblas-dev liblapack-dev \
    libx11-dev libgtk-3-dev \
    libboost-python-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Create known_faces directory and attendance log
RUN mkdir -p /app/known_faces \
    && touch /app/attendance.csv \
    && chmod -R 777 /app

# Install Python dependencies including gunicorn
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# Expose port
EXPOSE 5000

# Run the app with Gunicorn for production
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
