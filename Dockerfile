ENV OMP_NUM_THREADS=1
ENV MKL_NUM_THREADS=1

FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app/src \
    UV_HTTP_TIMEOUT=600

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install uv package manager
RUN pip install --no-cache-dir --break-system-packages uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install locked dependencies system-wide
RUN uv pip install --system -r pyproject.toml

# Copy project files
COPY . .

EXPOSE 8000

# Target the app object inside api.py
CMD ["uvicorn", "mlops_practitioner_course.api:app", "--host", "0.0.0.0", "--port", "8000"]
