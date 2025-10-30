import streamlit as st
import pandas as pd
import plotly.express as px

# ========================
# Load CSV Data
# ========================
@st.cache_data
def load_data():
    dim_student = pd.read_csv("DimStudent.csv")
    dim_subject = pd.read_csv("DimSubject.csv")
    dim_att_status = pd.read_csv("DimAttendanceStatus.csv")
    dim_date = pd.read_csv("dim_date.csv")
    dim_score_type = pd.read_csv("dim_score_type.csv")
    fact_attendance = pd.read_csv("FactAttendance.csv")
    fact_scores = pd.read_csv("FactScores.csv")
    return dim_student, dim_subject, dim_att_status, dim_date, dim_score_type, fact_attendance, fact_scores

dim_student, dim_subject, dim_att_status, dim_date, dim_score_type, fact_attendance, fact_scores = load_data()

st.set_page_config(page_title="Student Analytics Dashboard", layout="wide")
st.title("🎓 Student Analytics Dashboard")
st.markdown("### تحليل شامل للحضور والدرجات والطلاب")

# ========================
# Tabs
# ========================
tab1, tab2, tab3 = st.tabs(["📅 Attendance Analysis", "📈 Scores Analysis", "👨‍🎓 Students Insights"])

# ========================
# Tab 1: Attendance
# ========================
with tab1:
    st.subheader("Attendance Overview")

    df_att = (
        fact_attendance
        .merge(dim_student, on="Student_ID", how="left")
        .merge(dim_subject, left_on="Subject_key", right_on=dim_subject.columns[0], how="left")
        .merge(dim_att_status, left_on="Attendance_Status_key", right_on=dim_att_status.columns[0], how="left")
        .merge(dim_date, on="DateKey", how="left")
    )

    rows_to_show = st.slider("عدد الصفوف التي تظهر للمعاينة:", 5, len(df_att), 5)
    st.dataframe(df_att.head(rows_to_show), use_container_width=True)
    st.caption("⚠️ التحليل التالي يستخدم كل البيانات، وليس فقط الصفوف المعروضة أعلاه.")

    # ========== Attendance Distribution
    status_col = [c for c in df_att.columns if "status" in c.lower()]
    if status_col:
        col = status_col[-1]
        attendance_counts = df_att[col].value_counts().reset_index()
        attendance_counts.columns = ["Status", "Count"]
        fig = px.pie(attendance_counts, names="Status", values="Count", title="Attendance Distribution (All Data)")
        st.plotly_chart(fig, use_container_width=True)

    # ========== Attendance by Subject
    subject_col = [c for c in df_att.columns if "subject" in c.lower()]
    if subject_col and status_col:
        subj = subject_col[-1]
        att_per_subject = df_att.groupby([subj, col]).size().unstack(fill_value=0)
        fig_bar = px.bar(
            att_per_subject,
            x=att_per_subject.index,
            y=att_per_subject.columns,
            barmode="group",
            title="Attendance by Subject (All Data)"
        )
        st.plotly_chart(fig_bar, use_container_width=True)

# ========================
# Tab 2: Scores
# ========================
with tab2:
    st.subheader("Scores Overview")

    df_scores = (
        fact_scores
        .merge(dim_student, on="Student_ID", how="left")
        .merge(dim_subject, left_on="Subject_key", right_on=dim_subject.columns[0], how="left")
        .merge(dim_score_type, on=dim_score_type.columns[0], how="left")
        .merge(dim_date, on="DateKey", how="left")
    )

    rows_to_show_scores = st.slider("عدد الصفوف التي تظهر للمعاينة (Scores):", 5, len(df_scores), 5)
    st.dataframe(df_scores.head(rows_to_show_scores), use_container_width=True)
    st.caption("⚠️ التحليل التالي يستخدم كل البيانات، وليس فقط الصفوف المعروضة أعلاه.")

    # ========== Average Score per Subject
    if "Score" in df_scores.columns and "Subject_key" in df_scores.columns:
        avg_scores = df_scores.groupby("Subject_key")["Score"].mean().reset_index()
        fig = px.bar(avg_scores, x="Subject_key", y="Score", title="Average Score per Subject (All Data)")
        st.plotly_chart(fig, use_container_width=True)

    # ========== Average Score per Grade
    if "Score" in df_scores.columns and "Grade_Level" in df_scores.columns:
        avg_grade = df_scores.groupby("Grade_Level")["Score"].mean().reset_index()
        fig2 = px.line(avg_grade, x="Grade_Level", y="Score", title="Average Score per Grade Level (All Data)")
        st.plotly_chart(fig2, use_container_width=True)

# ========================
# Tab 3: Students Insights
# ========================
with tab3:
    st.subheader("Students Insights (All Students)")

    # ==== Top Students by Average Score
    if "Score" in df_scores.columns and "Full_Name" in df_scores.columns:
        avg_student_score = df_scores.groupby("Full_Name")["Score"].mean().reset_index()
        top_students = avg_student_score.sort_values(by="Score", ascending=False).head(15)
        fig3 = px.bar(top_students, x="Full_Name", y="Score", title="Top 15 Students by Average Score")
        st.plotly_chart(fig3, use_container_width=True)

    # ==== Attendance Ratio per Student (كل الطلاب)
    if "Attendance_Status_key" in df_att.columns and "Full_Name" in df_att.columns:
        present_mask = df_att["Attendance_Status_key"].astype(str).str.contains("1|Present|حاضر", case=False, na=False)
        att_ratio = present_mask.groupby(df_att["Full_Name"]).mean().reset_index(name="AttendanceRatio")
        fig4 = px.histogram(att_ratio, x="AttendanceRatio", nbins=20, title="Distribution of Attendance Ratio (All Students)")
        st.plotly_chart(fig4, use_container_width=True)

    # ==== Average Attendance by Grade
    if "Grade_Level" in df_att.columns:
        grade_att = present_mask.groupby(df_att["Grade_Level"]).mean().reset_index(name="AvgAttendanceRatio")
        fig5 = px.bar(grade_att, x="Grade_Level", y="AvgAttendanceRatio", title="Average Attendance Ratio per Grade")
        st.plotly_chart(fig5, use_container_width=True)

st.markdown("---")
st.caption("📊 Developed using Streamlit + Plotly | Dataset: Our Warehouse Project")
