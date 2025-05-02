import React from "react";
import { IconButton } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import NewBookForm from "./NewBookForm";

function NewBookButton() {
  const [open, setOpen] = React.useState(false);

  const handleOpen = () => setOpen(true);

  const handleClose = () => setOpen(false);

  return (
    <div>
      <IconButton
        style={{ backgroundColor: "white" }}
        aria-label="add"
        onClick={() => handleOpen()}
      >
        <AddIcon />
      </IconButton>
      <NewBookForm open={open} handleClose={handleClose} />
    </div>
  );
}

export default NewBookButton;
