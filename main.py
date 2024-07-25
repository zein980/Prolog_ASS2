import tkinter as tk
import subprocess

def run_prolog():
    m = int(m_entry.get())
    n = int(n_entry.get())
    x1 = int(x1_entry.get())
    y1 = int(y1_entry.get())
    x2 = int(x2_entry.get())
    y2 = int(y2_entry.get())
    result = subprocess.check_output(['swipl', '-q', '-f', 'part1.pl', '-g', f'create({m},{n},{x1},{y1},{x2},{y2})', '-t', 'halt'])
    result_label.config(text=result.decode())

# Create the main window
window = tk.Tk()
window.title("Domino Piling")
window.configure(background="#20B2AA")

# Create the input fields and labels
m_label = tk.Label(window, text="M:",font=("Arial", 10,"italic"))
m_entry = tk.Entry(window)
n_label = tk.Label(window, text="N:",font=("Arial", 10,"italic"))
n_entry = tk.Entry(window)
x1_label = tk.Label(window, text="Bomb X1:",font=("Arial", 10,"italic"))
x1_entry = tk.Entry(window)
y1_label = tk.Label(window, text="Bomb Y1:",font=("Arial", 10,"italic"))
y1_entry = tk.Entry(window)
x2_label = tk.Label(window, text="Bomb X2:",font=("Arial", 10,"italic"))
x2_entry = tk.Entry(window)
y2_label = tk.Label(window, text="Bomb Y2:",font=("Arial", 10,"italic"))
y2_entry = tk.Entry(window)

# Create the button to run the Prolog predicate
run_button = tk.Button(window, text="Run",font=("Arial", 10,"italic"), command=run_prolog,width=100,height=2,background="gray")
result_label = tk.Label(window, text="",width=100,height=20,background="#20B2AA")

m_label.config(bg="#20B2AA")
m_label.grid(row=0, column=0, padx=(10, 0), pady=(10, 0))
m_entry.grid(row=0, column=1, padx=(10, 0), pady=(10, 0))


n_label.config(bg="#20B2AA")
n_label.grid(row=0, column=2, padx=(10, 0), pady=(10, 0))
n_entry.grid(row=0, column=3, padx=(10, 0), pady=(10, 0))


x1_label.config(bg="#20B2AA")
x1_label.grid(row=4, column=0, padx=(10, 0), pady=(20, 0))
x1_entry.grid(row=4, column=1, padx=(10, 0), pady=(20, 0))



y1_label.config(bg="#20B2AA")
y1_label.grid(row=4, column=2, padx=(10, 0) ,pady=(20, 0))
y1_entry.grid(row=4, column=3, padx=(10, 0), pady=(20, 0))


x2_label.config(bg="#20B2AA")
x2_label.grid(row=7, column=0, padx=(10, 0) ,pady=(30, 0))
x2_entry.grid(row=7, column=1, padx=(10, 0), pady=(30, 0))


y2_label.config(bg="#20B2AA")
y2_label.grid(row=7, column=2, padx=(10, 0), pady=(30, 0))
y2_entry.grid(row=7, column=3, padx=(10, 0), pady=(30, 0))

run_button.grid(row=14, column=0, columnspan=4, pady=(30, 2))

result_label.grid(row=21, column=0, columnspan=4, pady=(6, 10), sticky=tk.N)


# Start the main event loop
window.mainloop()
