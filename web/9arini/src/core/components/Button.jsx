// /core/components/Button.jsx
export default function Button({ children, ...props }) {
  return (
    <button {...props}>{children}</button>
  );
}
