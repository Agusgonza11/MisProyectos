import React, { useContext, useState } from "react";
import { Button, Menu, MenuItem } from "@mui/material";
import { ArrowDropDown } from "@mui/icons-material";
import { BookContext } from "../../contexts/BookContext";
import { BookStatus } from "../../contexts/BookContext";

interface BookStatusDropdownProps {
  userId: number | 0;
  bookId: number;
  initialStatus?: BookStatus;
  onStatusChange?: (newStatus: BookStatus) => void;
}

export default function BookStatusDropdown({
  userId,
  bookId,
  initialStatus = BookStatus.ChooseStatus,
  onStatusChange,
}: BookStatusDropdownProps) {
  const [status, setStatus] = useState<BookStatus>(initialStatus);
  const [anchorElement, setAnchorElement] = useState<null | HTMLElement>(null);
  const bookContext = useContext(BookContext);
  const { markBookAsPlanToRead, markBookAsReading, markBookAsRead } =
    bookContext;

  const statusColors = {
    [BookStatus.PlanToRead]: "#4DB6AC",
    [BookStatus.Reading]: "#FFA726",
    [BookStatus.Read]: "#66BB6A",
    [BookStatus.ChooseStatus]: "#CCCCCC",
  };

  const statusHoverColors = {
    [BookStatus.PlanToRead]: "#009688",
    [BookStatus.Reading]: "#FB8C00",
    [BookStatus.Read]: "#43A047",
    [BookStatus.ChooseStatus]: "#CCCCCC",
  };

  const statusLabels = {
    [BookStatus.PlanToRead]: "Planeo leer",
    [BookStatus.Reading]: "Actualmente leyendo",
    [BookStatus.Read]: "Leído",
    [BookStatus.ChooseStatus]: "Elegir estado",
  };

  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    setAnchorElement(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorElement(null);
  };

  const handleStatusChange = async (newStatus: BookStatus) => {
    setStatus(newStatus);
    handleClose();

    switch (newStatus) {
      case BookStatus.PlanToRead:
        markBookAsPlanToRead(userId, bookId);
        break;
      case BookStatus.Reading:
        markBookAsReading(userId, bookId);
        break;
      case BookStatus.Read:
        markBookAsRead(userId, bookId);
        break;
    }

    if (onStatusChange) {
      onStatusChange(newStatus);
    }
  };

  return (
    <div>
      <Button
        fullWidth
        variant="contained"
        onClick={handleClick}
        endIcon={<ArrowDropDown />}
        sx={{
          backgroundColor: statusColors[status],
          "&:hover": { backgroundColor: statusHoverColors[status] },
          whiteSpace: "nowrap",
        }}
      >
        {statusLabels[status]}
      </Button>
      <Menu
        anchorEl={anchorElement}
        open={Boolean(anchorElement)}
        onClose={handleClose}
      >
        <MenuItem onClick={() => handleStatusChange(BookStatus.PlanToRead)}>
          {statusLabels[BookStatus.PlanToRead]}
        </MenuItem>
        <MenuItem onClick={() => handleStatusChange(BookStatus.Reading)}>
          {statusLabels[BookStatus.Reading]}
        </MenuItem>
        <MenuItem onClick={() => handleStatusChange(BookStatus.Read)}>
          {statusLabels[BookStatus.Read]}
        </MenuItem>
      </Menu>
    </div>
  );
}
