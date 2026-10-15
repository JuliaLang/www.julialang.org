/**
 * Animated Banner - Dense Tessellated Triangle Pattern
 * Recreates the original Julia banner with organic morphing
 */

(function() {
  'use strict';

const config = {
  colors: [
    'rgba(56, 152, 38, 0.5)',   // Julia green
    'rgba(203, 60, 51, 0.5)',   // Julia red
    'rgba(149, 88, 178, 0.5)',  // Julia purple
    'rgba(64, 99, 216, 0.5)'    // Julia blue
  ],
  backgroundColor: '#1a1a33',
  morphSpeed: 0.005,     // Increased for more visible movement
  morphRange: 15,        // Increased amplitude for more visible morphing
  triangleSize: 70,      // Average size of triangles
  density: 10.0           // Triangles per 100x100 area
};

// Shared vertex system to prevent overlaps
class VertexPool {
  constructor(width, height, spacing) {
    this.vertices = new Map();
    this.spacing = spacing;
    this.width = width;
    this.height = height;
    this.createGrid();
  }

  createGrid() {
    // Create a grid of shared vertices
    for (let y = -100; y < this.height + 100; y += this.spacing) {
      for (let x = -100; x < this.width + 100; x += this.spacing) {
        // Add some randomness to vertex positions
        const offsetX = (Math.random() - 0.5) * this.spacing * 0.6;
        const offsetY = (Math.random() - 0.5) * this.spacing * 0.6;

        const vertex = {
          origX: x + offsetX,
          origY: y + offsetY,
          x: x + offsetX,
          y: y + offsetY,
          phase: Math.random() * Math.PI * 2,
          speedX: 0.5 + Math.random() * 0.5,
          speedY: 0.5 + Math.random() * 0.5,
          phaseOffsetX: Math.random() * Math.PI * 2,
          phaseOffsetY: Math.random() * Math.PI * 2
        };

        this.vertices.set(`${x},${y}`, vertex);
      }
    }
  }

  getVertex(x, y) {
    return this.vertices.get(`${x},${y}`);
  }

  getNearbyVertices(x, y, maxDistance) {
    const nearby = [];
    for (const [key, vertex] of this.vertices) {
      const dx = vertex.origX - x;
      const dy = vertex.origY - y;
      const dist = Math.sqrt(dx * dx + dy * dy);
      if (dist < maxDistance && dist > 1) {
        nearby.push({ vertex, distance: dist });
      }
    }
    return nearby.sort((a, b) => a.distance - b.distance);
  }

  update(time) {
    const t = time * config.morphSpeed;

    for (const vertex of this.vertices.values()) {
      // Morph vertices with constrained sine waves
      const morphX = Math.sin(t * vertex.speedX + vertex.phaseOffsetX) * config.morphRange;
      const morphY = Math.cos(t * vertex.speedY + vertex.phaseOffsetY) * config.morphRange;

      vertex.x = vertex.origX + morphX;
      vertex.y = vertex.origY + morphY;
    }
  }
}

class Triangle {
  constructor(v1, v2, v3, color) {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
    this.color = color;
  }

  draw(ctx) {
    ctx.fillStyle = this.color;
    ctx.beginPath();
    ctx.moveTo(this.v1.x, this.v1.y);
    ctx.lineTo(this.v2.x, this.v2.y);
    ctx.lineTo(this.v3.x, this.v3.y);
    ctx.closePath();
    ctx.fill();
  }
}

class AnimatedBanner {
  constructor(canvasId) {
    this.canvas = document.getElementById(canvasId);
    if (!this.canvas) {
      console.error('Canvas element not found');
      return;
    }

    this.ctx = this.canvas.getContext('2d');
    this.triangles = [];
    this.time = 0;

    this.resize();
    this.generatePattern();
    this.animate();

    // Handle window resize - only resize canvas, don't regenerate pattern
    let resizeTimeout;
    window.addEventListener('resize', () => {
      clearTimeout(resizeTimeout);
      resizeTimeout = setTimeout(() => {
        this.resize();
      }, 100);
    });
  }

  resize() {
    const rect = this.canvas.getBoundingClientRect();
    this.canvas.width = rect.width;
    this.canvas.height = rect.height;
  }

  generatePattern() {
    this.triangles = [];
    const width = this.canvas.width;
    const height = this.canvas.height;

    // Create vertex pool
    this.vertexPool = new VertexPool(width, height, config.triangleSize * 0.7);

    // Generate triangles by connecting nearby vertices
    const area = width * height;
    const numTriangles = Math.floor(area / 10000 * config.density);

    const vertexArray = Array.from(this.vertexPool.vertices.values());

    for (let i = 0; i < numTriangles; i++) {
      // Pick a random starting vertex
      const v1 = vertexArray[Math.floor(Math.random() * vertexArray.length)];

      // Find nearby vertices
      const nearby = this.vertexPool.getNearbyVertices(v1.origX, v1.origY, config.triangleSize * 1.5);

      if (nearby.length < 2) continue;

      // Pick two nearby vertices to form a triangle
      const v2 = nearby[Math.floor(Math.random() * Math.min(5, nearby.length))].vertex;
      const v3 = nearby[Math.floor(Math.random() * Math.min(5, nearby.length))].vertex;

      // Check if triangle is valid (not too small or degenerate)
      const area = Math.abs(
        (v2.origX - v1.origX) * (v3.origY - v1.origY) -
        (v3.origX - v1.origX) * (v2.origY - v1.origY)
      ) / 2;

      if (area > 200 && area < 5000) {
        const color = config.colors[Math.floor(Math.random() * config.colors.length)];
        this.triangles.push(new Triangle(v1, v2, v3, color));
      }
    }
  }

  animate() {
    this.time++;

    // Update all vertices
    this.vertexPool.update(this.time);

    // Clear canvas
    this.ctx.fillStyle = config.backgroundColor;
    this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);

    // Draw all triangles
    for (const triangle of this.triangles) {
      triangle.draw(this.ctx);
    }

    requestAnimationFrame(() => this.animate());
  }
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    new AnimatedBanner('animated-banner');
  });
} else {
  new AnimatedBanner('animated-banner');
}

})(); // End IIFE