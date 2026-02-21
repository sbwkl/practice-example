# Todo Frontend

A modern Todo List application built with [Vue 3](https://vuejs.org/) and [Vite](https://vitejs.dev/). This application provides a user interface to manage todo items, communicating with a backend service.

## Features

- **View Todos**: Display a list of todo items.
- **Add Todo**: Create new todo items.
- **Edit Todo**: Double-click to edit existing items.
- **Delete Todo**: Remove items from the list.
- **Toggle Status**: Mark items as completed or pending.
- **Dual Storage Mode**: Switch between Remote API and Local Storage (LocalStorage) when the backend is unavailable.

## Project Structure

```
todo-frontend/
├── public/              # Static assets
├── src/
│   ├── assets/          # Project assets (css, images)
│   ├── components/      # Vue components
│   │   └── Todo.vue     # Main Todo list component
│   ├── services/        # API services
│   │   ├── api.js           # Axios configuration and API endpoints
│   │   ├── localService.js  # LocalStorage implementation
│   │   └── todoService.js   # Proxy service for switching modes
│   ├── App.vue          # Root component
│   ├── main.js          # Application entry point
│   └── style.css        # Global styles
├── index.html           # HTML entry point
├── package.json         # Project dependencies and scripts
└── vite.config.js       # Vite configuration
```

## Getting Started

### Prerequisites

- **Node.js**: v16 or higher recommended.
- **npm**: Node Package Manager.

### Installation

1.  Clone the repository (if applicable) or navigate to the project directory:
    ```bash
    cd todo-frontend
    ```

2.  Install dependencies:
    ```bash
    npm install
    ```

## Development

### Running Locally

To start the development server:

```bash
npm run dev
```

The application will be available at `http://localhost:5173` (default Vite port).

### Building for Production

To build the application for production:

```bash
npm run build
```

The build artifacts will be stored in the `dist/` directory.

### Preview Production Build

To locally preview the production build:

```bash
npm run preview
```

## Configuration

### Storage Mode

The application supports two storage modes:
- **Remote**: Connects to the backend API (default).
- **Local**: Uses the browser's `localStorage`.

You can switch between these modes using the "Switch" button in the Todo List interface. The application also checks for API availability on startup and displays a warning if the backend is unreachable.

### API Configuration

The application communicates with a backend service. The API base URL is configured in `src/services/api.js`.

Default configuration:
```javascript
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api', // Backend API URL
  headers: {
    'Content-Type': 'application/json'
  }
});
```

Ensure your backend service is running and accessible at this URL, or update the `baseURL` to match your environment.

## Technologies Used

- **Vue 3**: The Progressive JavaScript Framework.
- **Vite**: Next Generation Frontend Tooling.
- **Axios**: Promise based HTTP client for the browser and node.js.
