import React from 'react';

export default function ProgressBar({ percentage }) {
  return (
    <div style={{ width: '100%', background: '#e5e7eb', borderRadius: '10px', height: '10px', overflow: 'hidden', marginTop: '10px' }}>
      <div 
        style={{ 
          width: `${percentage}%`, 
          background: '#2563eb', 
          height: '100%', 
          transition: 'width 0.5s ease-in-out' 
        }} 
      />
      <div style={{fontSize: '12px', textAlign: 'right', marginTop: '4px', color: '#666'}}>
        {percentage}% Complété
      </div>
    </div>
  );
}
