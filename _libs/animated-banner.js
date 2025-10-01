// Animated tessellated banner - calm, organic triangle morphing
(function() {
    'use strict';
    
    const config = {
        width: 2100,
        height: 350,
        triangleDensity: 0.15, // controls spacing between triangles
        morphSpeed: 0.0003, // slower = calmer
        morphRange: 8, // max pixel deviation from original position
        colors: [
            { fill: '#389826', opacity: 0.5 }, // green
            { fill: '#cb3c33', opacity: 0.5 }, // red
            { fill: '#9558b2', opacity: 0.5 }, // purple
            { fill: '#4063d8', opacity: 0.5 }  // blue
        ]
    };
    
    class Triangle {
        constructor(x1, y1, x2, y2, x3, y3, colorIndex) {
            // Store original positions
            this.origX1 = x1; this.origY1 = y1;
            this.origX2 = x2; this.origY2 = y2;
            this.origX3 = x3; this.origY3 = y3;
            
            // Current positions (will morph)
            this.x1 = x1; this.y1 = y1;
            this.x2 = x2; this.y2 = y2;
            this.x3 = x3; this.y3 = y3;
            
            // Phase offsets for smooth, varied motion
            this.phase1 = Math.random() * Math.PI * 2;
            this.phase2 = Math.random() * Math.PI * 2;
            this.phase3 = Math.random() * Math.PI * 2;
            
            // Speed variation for each vertex
            this.speed1 = 0.8 + Math.random() * 0.4;
            this.speed2 = 0.8 + Math.random() * 0.4;
            this.speed3 = 0.8 + Math.random() * 0.4;
            
            this.color = config.colors[colorIndex];
        }
        
        update(time) {
            // Subtle sine wave motion for each vertex
            const t = time * config.morphSpeed;
            
            this.x1 = this.origX1 + Math.sin(t * this.speed1 + this.phase1) * config.morphRange;
            this.y1 = this.origY1 + Math.cos(t * this.speed1 * 1.3 + this.phase1) * config.morphRange;
            
            this.x2 = this.origX2 + Math.sin(t * this.speed2 + this.phase2) * config.morphRange;
            this.y2 = this.origY2 + Math.cos(t * this.speed2 * 1.1 + this.phase2) * config.morphRange;
            
            this.x3 = this.origX3 + Math.sin(t * this.speed3 + this.phase3) * config.morphRange;
            this.y3 = this.origY3 + Math.cos(t * this.speed3 * 0.9 + this.phase3) * config.morphRange;
        }
        
        draw(ctx) {
            ctx.fillStyle = this.color.fill;
            ctx.globalAlpha = this.color.opacity;
            ctx.beginPath();
            ctx.moveTo(this.x1, this.y1);
            ctx.lineTo(this.x2, this.y2);
            ctx.lineTo(this.x3, this.y3);
            ctx.closePath();
            ctx.fill();
        }
    }
    
    class AnimatedBanner {
        constructor(canvasId) {
            this.canvas = document.getElementById(canvasId);
            if (!this.canvas) return;
            
            this.ctx = this.canvas.getContext('2d');
            this.triangles = [];
            this.lastTime = 0;
            
            this.setupCanvas();
            this.generateTriangles();
            this.animate(0);
        }
        
        setupCanvas() {
            this.canvas.width = config.width;
            this.canvas.height = config.height;
            this.canvas.style.width = '100%';
            this.canvas.style.height = '100%';
        }
        
        generateTriangles() {
            // Generate a tessellated pattern of triangles
            const gridSize = 60; // size of each grid cell
            const rows = Math.ceil(config.height / gridSize) + 1;
            const cols = Math.ceil(config.width / gridSize) + 1;
            
            for (let row = -1; row < rows; row++) {
                for (let col = -1; col < cols; col++) {
                    const x = col * gridSize;
                    const y = row * gridSize;
                    const offset = (row % 2) * gridSize * 0.5;
                    
                    // Create varied triangle patterns
                    const pattern = Math.floor(Math.random() * 4);
                    const colorIdx = Math.floor(Math.random() * 4);
                    
                    switch(pattern) {
                        case 0:
                            // Upper left
                            this.triangles.push(new Triangle(
                                x + offset, y,
                                x + gridSize + offset, y,
                                x + offset, y + gridSize,
                                colorIdx
                            ));
                            // Lower right
                            this.triangles.push(new Triangle(
                                x + gridSize + offset, y,
                                x + gridSize + offset, y + gridSize,
                                x + offset, y + gridSize,
                                (colorIdx + 1) % 4
                            ));
                            break;
                        case 1:
                            // Upper right
                            this.triangles.push(new Triangle(
                                x + offset, y,
                                x + gridSize + offset, y,
                                x + gridSize + offset, y + gridSize,
                                colorIdx
                            ));
                            // Lower left
                            this.triangles.push(new Triangle(
                                x + offset, y,
                                x + gridSize + offset, y + gridSize,
                                x + offset, y + gridSize,
                                (colorIdx + 2) % 4
                            ));
                            break;
                        case 2:
                            // Center split triangles
                            const midX = x + gridSize * 0.5 + offset;
                            const midY = y + gridSize * 0.5;
                            this.triangles.push(new Triangle(
                                x + offset, y,
                                x + gridSize + offset, y,
                                midX, midY,
                                colorIdx
                            ));
                            this.triangles.push(new Triangle(
                                x + gridSize + offset, y,
                                x + gridSize + offset, y + gridSize,
                                midX, midY,
                                (colorIdx + 1) % 4
                            ));
                            this.triangles.push(new Triangle(
                                x + gridSize + offset, y + gridSize,
                                x + offset, y + gridSize,
                                midX, midY,
                                (colorIdx + 2) % 4
                            ));
                            this.triangles.push(new Triangle(
                                x + offset, y + gridSize,
                                x + offset, y,
                                midX, midY,
                                (colorIdx + 3) % 4
                            ));
                            break;
                        case 3:
                            // Diagonal split
                            this.triangles.push(new Triangle(
                                x + offset, y,
                                x + gridSize + offset, y + gridSize,
                                x + offset, y + gridSize,
                                colorIdx
                            ));
                            this.triangles.push(new Triangle(
                                x + offset, y,
                                x + gridSize + offset, y,
                                x + gridSize + offset, y + gridSize,
                                (colorIdx + 3) % 4
                            ));
                            break;
                    }
                }
            }
        }
        
        animate(time) {
            // Clear canvas
            this.ctx.fillStyle = '#1a1a33';
            this.ctx.fillRect(0, 0, config.width, config.height);
            
            // Update and draw all triangles
            for (let tri of this.triangles) {
                tri.update(time);
                tri.draw(this.ctx);
            }
            
            // Continue animation
            requestAnimationFrame((t) => this.animate(t));
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
})();
