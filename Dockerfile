## `python-base` sets up all our shared environment variables
FROM python:3.12-slim as python-base

# Define environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.0.3 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

# Prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# Update and install necessary packages
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        build-essential \
        python3-dev \
        libpq-dev \
        gcc

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python -

# Install Postgres dependencies inside Docker
RUN apt-get update \
    && apt-get -y install libpq-dev gcc

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Copy project requirement files
COPY poetry.lock pyproject.toml $PYSETUP_PATH/

# Install runtime dependencies
RUN poetry install --no-dev

# Expose port
EXPOSE 8000

# Command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
